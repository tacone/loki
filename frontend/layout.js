const Layout = (props) => {
  return (
    <div className="container container-md">
      <h1 className="header">
        <a href="/">
          <img className="logo" src="/images/logo.svg" />
        </a>
        The survey
      </h1>

      {props.children}
    </div>
  );
};

export default Layout;
