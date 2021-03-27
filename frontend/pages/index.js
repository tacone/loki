import Layout from "layout";
import Head from "next/head";

export default function Home() {
  return (
    <Layout>
      <Head>
        <title>Survey</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <p>Completa questo breve questionario per darci la tua impressione.</p>
      <p>
        <a href="/quiz" className="btn btn-primary btn-lg">
          Comincia
        </a>
      </p>
      <p>&nbsp;</p>
      <p>
        <a href="/results" className="btn btn-success btn-lg">
          Risultati
        </a>
      </p>
    </Layout>
  );
}
