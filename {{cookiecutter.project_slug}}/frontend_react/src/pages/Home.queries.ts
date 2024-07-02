import axios from 'axios'
export const fetchMe = async () => {
  const { data } = await axios.get('/api/users/me')
  return data
}
