import Layout from "layout";
import Link from "next/link"
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
        <Link href="/quiz">
          <a className="btn btn-primary btn-lg">Comincia</a>
        </Link>
      </p>
      <p>&nbsp;</p>
      <p>
      <Link href="/results">
        <a className="btn btn-success btn-lg">
          Risultati
        </a></Link>
      </p>
    </Layout>
  );
}
