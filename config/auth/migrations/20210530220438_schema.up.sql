/*
	exclude the freaking table from the graphql schema
*/

COMMENT ON TABLE public.schema_migration IS '
@omit

=========================== IMPORTANT ===================================
As long as you don’t plan to run the migrations again (why should you？)
you can and are encouraged to delete this table.

Do so by running this query:

DROP TABLE IF EXISTS public.schema_migration

=========================================================================
';
