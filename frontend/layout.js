import Link from "next/link";

const Layout = (props) => {
  return (
    <div className="container container-md">
      <h1 className="header">
        <Link href="/">
          <a>
            <img className="logo" src="/images/logo.svg" />
          </a>
        </Link>
        The survey
      </h1>

      {props.children}
    </div>
  );
};

export default Layout;
