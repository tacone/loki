import Survey from "components/survey";
import Layout from "layout";
import Head from "next/head";
import { useRouter } from "next/router";

export default function Home() {
  const router = useRouter();
  const from = router.query.from;
  if (typeof document !== "undefined") {
    const referrer = document.referrer;
    if (referrer && !from) {
      router.push(`/quiz?from=${escape(referrer)}`);
    }
  }

  return (
    <Layout>
      <Head>
        <title>Survey</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <p>Completa questo breve questionario per darci la tua impressione.</p>
      <p>
        <span className="text-muted">
          (<strong>ps: </strong>quis fugiat officia nisi aute et. Irure
          reprehenderit proident fugiat labore sint voluptate voluptate enim ad
          aliquip do elit. Nulla ad ex eiusmod ipsum consequat incididunt do non
          eu officia fugiat cillum nulla tempor.)
        </span>
      </p>

      <Survey referrer={from} />
    </Layout>
  );
}
