import { gql, useQuery } from "@apollo/client";
import ClientOnly from "components/client-only";
import Grid from "components/grid";
import Result from "components/result";
import Layout from "layout";
import Head from "next/head";

const QUERY = gql`
  query {
    submission_statistics {
      age {
        value
        count
        ratio
      }
      country {
        value
        count
        ratio
      }
      gender {
        value
        count
        ratio
      }
      experience_rating {
        value
        count
        ratio
      }
      total_submissions
    }
  }
`;

export default function Home() {
  const { data, loading, error } = useQuery(QUERY);
  let recordsets = [];
  const totalSubmissions = "";

  if (error) {
    console.error(error);
  } else if (!loading) {
    recordsets = data["submission_statistics"];
    totalSubmissions = recordsets["total_submissions"];
  }

  return (
    <Layout>
      <Head>
        <title>Survey</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <ClientOnly>
        {loading && <h2>loading...</h2>}
        {error && !loading && (
          <div>
            <h2>Error</h2>
            <p>{error.message}</p>
          </div>
        )}
        {!loading && !error && (
          <>
            <h2 className="page-title">Risultati ({totalSubmissions} invii)</h2>
            <Grid
              columns={2}
              children={["age", "country", "gender", "experience_rating"].map(
                (name) => {
                  return (
                    <Result key={name} name={name} records={recordsets[name]} />
                  );
                }
              )}
            ></Grid>
          </>
        )}
      </ClientOnly>
    </Layout>
  );
}
