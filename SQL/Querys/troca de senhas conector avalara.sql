-- ATUALIZACAO DE LINK
UPDATE
	XXAVL.xxavl_login_token
SET HOST = 'https://avataxbr.sandbox.avalarabrasil.com.br/v2/'
WHERE HOST != 'https://avataxbr.sandbox.avalarabrasil.com.br/v2/';

-- ATUALIZA ID 1
update
	xxavl.xxavl_login_token
set senha = 'Go1AM'||chr(38)||'JWB^azs#6MsFXO0sMzEk3sf4'
where
	id_login = 1
and usuario = 'intebs.kawasaki';

-- ATUALIZA ID 2
update
	xxavl.xxavl_login_token
set	senha = 'adm123!'
where
	id_login = 2
and usuario = 'adm.kawasaki';

-- ATUALIZA ID 3
update
	xxavl.xxavl_login_token
set	senha = '2bc7e!V)9PGwom1tWx'
where
	id_login = 3
and usuario = 'intebs.kawasaki2';

select senha from xxavl.xxavl_login_token where id_login = 1
union all
select 'Go1AM'||chr(38)||'JWB^azs#6MsFXO0sMzEk3sf4'as senha from dual;