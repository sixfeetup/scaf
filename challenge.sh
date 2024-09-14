#!/bin/bash

# Define the function to handle the scaff challenge auth flow
run_scaf_challenge_oauth_flow() {
  # Create a temporary Python script
  cat << EOF > temp_server.py
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs
import os
import signal

class TokenHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        parsed_path = urlparse(self.path)
        query_params = parse_qs(parsed_path.query)
        if 'code' in query_params:
            code = query_params['code'][0]
            with open('code.txt', 'w') as f:
                f.write(code)
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b"Authentication was successful. You can close this window now. Thank you!")
            # Signal the parent process
            os.kill(os.getppid(), signal.SIGUSR1)
        else:
            self.send_response(400)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b"Error: No code provided in the URL.")

def run_server(port=51111):
    server_address = ('', port)
    httpd = HTTPServer(server_address, TokenHandler)
    httpd.serve_forever()

if __name__ == '__main__':
    run_server()
EOF

  # Function to handle the SIGUSR1 signal
  code_received() {
      # Token received. Proceeding to kill HTTP server process.
      kill $server_pid
  }

  # Set up the signal handler
  trap code_received SIGUSR1

  # Start the Python server in the background
  python temp_server.py &
  server_pid=$!

  # Example opening of the browser to auth/reg user
  python -c "import webbrowser; webbrowser.open('https://scaf.withpassage.com/authorize?response_type=code&client_id=961JRDH4c4Sin8LYGGbI0Lb7&redirect_uri=http://localhost:51111&scope=openid%20email')"

  echo "Waiting for authorization..."

  # Wait for the Python script to exit
  wait $server_pid

  # Read the code
  code=$(cat code.txt)

  # Passage OIDC client credentials – move them? (for now, they are hardcoded)
  oidc_client_id="961JRDH4c4Sin8LYGGbI0Lb7"
  oidc_client_secret="<<CHANGEME>>"

  # Perform the curl request and capture the response
  response=$(curl -s --location --request POST "https://scaf.withpassage.com/token?grant_type=authorization_code&code=$code&redirect_uri=http%3A%2F%2Flocalhost%3A51111&client_id=$oidc_client_id&client_secret=$oidc_client_secret" \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data '')

  # Use grep and sed to extract the access_token from the JSON response
  access_token=$(echo $response | grep -o '"access_token":"[^"]*"' | sed -e 's/"access_token":"\([^"]*\)"/\1/')

  # Clean up the Python HTTP server script / code.txt
  rm temp_server.py
  rm code.txt

  # Check if the access_token exists and is not empty
  if [[ -n "$access_token" ]]; then
    echo "Authentication has been completed."
    # write challenge metadata to .scaf-challenge.json
    cat << EOF > .scaf-challenge.json
{
    "access_token": "$access_token",
    "session_id": "$(uuidgen)",
    "base_url": "https://dmxla4ubt9.execute-api.us-east-1.amazonaws.com"
}
EOF
  else
    echo "Error: Access token was not retrieved."
    exit 1
  fi
}
