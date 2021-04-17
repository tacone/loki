import Document, { Html, Head, Main, NextScript } from 'next/document'

// we need this file to avoid FOUC on Firefox in production mode
// https://github.com/vercel/next.js/issues/18769


exports.PERMANENT_REDIRECT_STATUS = 301

class MyDocument extends Document {
  static async getInitialProps(ctx) {
    const initialProps = await Document.getInitialProps(ctx)
    return { ...initialProps }
  }

  render() {
    return (
      <Html>
        <Head />
        <body>
          <script>0</script>
          <Main />
          <NextScript />
        </body>
      </Html>
    )
  }
}

export default MyDocument
