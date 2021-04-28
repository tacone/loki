import Layout from "layout";
import Head from "next/head";
import { useRouter } from "next/router";

export default function Home() {
  const router = useRouter();

  const from = router.query.from;
  const goBackUrl = from ? from : "/";
  return (
    <Layout>
      <Head>
        <title>Survey</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <h1 className="text-centered">Grazie!</h1>
      <p>
        Il questionario è stato inviato ed il tuo feedback verrà preso in
        considerazione
      </p>
      <p>
        <a className="btn btn-primary" href={goBackUrl}>
          Torna al sito project
        </a>
      </p>
    </Layout>
  );
}
