<header class="navbar navbar-darkx sticky-top bg-darkx flex-md-nowrap p-0 shadowx">
	<a class="navbar-brand col-md-3 col-lg-2 me-0 px-3" href="/">Company name</a>
	<button
		class="navbar-toggler position-absolute d-md-none collapsed"
		type="button"
		data-bs-toggle="collapse"
		data-bs-target="#sidebarMenu"
		aria-controls="sidebarMenu"
		aria-expanded="false"
		aria-label="Toggle navigation"
	>
		<span class="navbar-toggler-icon" />
	</button>
	<div class="dropdown w-100 m0">
		<input
			class="form-control form-control-darkx w-100 m0 border-0 shadow-none"
			type="text"
			placeholder="Press / to search"
			aria-label="Search"
		/>
		<ul class="dropdown-menu w-100 border-0 shadow" aria-labelledby="dropdownMenuButton1">
			<li><a class="dropdown-item" href="#">Action</a></li>
			<li><a class="dropdown-item" href="#">Another action</a></li>
			<li><a class="dropdown-item" href="#">Something else here</a></li>
		</ul>
	</div>
	<div class="navbar-nav">
		<div class="nav-item text-nowrap">
			<a class="nav-link px-3" href="#">Sign out</a>
		</div>
	</div>
</header>

<style>
	.navbar {
		height: 3em;
	}
	input {
		height: 3em;
	}
    input:focus::placeholder {
       color: transparent;
        content: "oijoi";
    }
    input:focus + .dropdown-menu {
        display: block;
    }
    .dropdown-menu {
        margin-top:-1px;
    }
    input:focus, input:focus + .dropdown-menu  {
        background: #f0f9fa;
    }
</style>
