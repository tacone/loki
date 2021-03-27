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
  if (loading) {
    return <h2>Loading...</h2>;
  }

  if (error) {
    console.error(error);
    return null;
  }

  const recordsets = data["submission_statistics"];
  const totalSubmissions = recordsets["total_submissions"];
  return (
    <Layout>
      <Head>
        <title>Survey</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <h2 className="page-title">Risultati ({totalSubmissions} invii)</h2>
      <ClientOnly>
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
      </ClientOnly>
    </Layout>
  );
}
