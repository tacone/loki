// put in this file the logic that applies to all the pages

// for apollo client
import { ApolloProvider } from "@apollo/react-hooks";
import { ApolloClient, HttpLink, InMemoryCache } from "apollo-boost";
import "../styles/index.scss";

function WrappedApp({ Component, pageProps }) {
  if (!process.env.NEXT_PUBLIC_GRAPHQL_ENDPOINT)
    throw new Error(
      JSON.stringify(process.env) +
        "Please configure the GRAPHQL_ENDPOINT variable in your .env file"
    );
  // for apollo client
  const httpLink = new HttpLink({
    uri: process.env.NEXT_PUBLIC_GRAPHQL_ENDPOINT,
  });

  const client = new ApolloClient({
    link: httpLink,
    cache: new InMemoryCache(),
  });

  return (
    <ApolloProvider client={client}>
      <Component {...pageProps} />
    </ApolloProvider>
  );
}

export default WrappedApp;

// // Sample custom app
//
// function MyApp({ Component, pageProps }) {
//     return <Component {...pageProps} />
//   }

// // Sample blocking data management
//
// Only uncomment this method if you have blocking data requirements for
// every single page in your application. This disables the ability to
// perform automatic static optimization, causing every page in your app to
// be server-side rendered.
//
// MyApp.getInitialProps = async (appContext) => {
//   // calls page's `getInitialProps` and fills `appProps.pageProps`
//   const appProps = await App.getInitialProps(appContext);
//
//   return { ...appProps }
// }

// export default App
