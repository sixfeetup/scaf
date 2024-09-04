This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started

Running the development server:

Tilt will automatically deploy a NextJS container for development, and it is recommended not to run NextJS locally.

Update the .env.local.example file to .env.local
Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `pages/index.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/basic-features/font-optimization) to automatically optimize and load Inter, a custom Google Font.
This project uses GraphQL for the backend, and Apollo Client for the frontend. The Apollo Client is set up in the `lib/apolloClient.ts` file.

## Environment Variables

| Variable Name                | Explanation                                                |
| ---------------------------- | ---------------------------------------------------------- | --- |
| IS_PRE_PUSH_HOOKS_ENABLED    | Controls husky pre-push hooks for frontend folder          |     |
| NEXT_PUBLIC_GRAPHQL_ENDPOINT | The public graphql endpoint url                            |
| NEXT_GRAPHQL_ENDPOINT        | The graphql endpoint url to be used for serverside queries |     |

## Suggested Tools

[Apollo Client Devtools](https://chromewebstore.google.com/detail/apollo-client-devtools/jdkknkkbebbapilgoeccciglkfbmbnfm)
[GraphQL Network Inspector](https://chromewebstore.google.com/detail/graphql-network-inspector/ndlbedplllcgconngcnfmkadhokfaaln)

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js/) - your feedback and contributions are welcome!

Check out the official [Next.js deployment documentation](https://nextjs.org/docs/deployment) for more details.
