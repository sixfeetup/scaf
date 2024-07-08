import { useQuery } from '@apollo/client'

import { gql } from '@/__generated__'

export const GET_ME = gql(/* GraphQL */ `
  query Me {
    me {
      id
      name
    }
  }
`)

export default function Home() {
  const { loading, error, data } = useQuery(GET_ME)

  if (loading) return <p>Loading...</p>
  return (
    <>
      <h1>Home Page</h1>
      <p>This page using Client Side Rendering to fetch User Info</p>
      {error ? <p>Error: {error.message}</p> : <p>{data?.me.name}</p>}
    </>
  )
}
