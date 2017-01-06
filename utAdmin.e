class UTADMIN


creation{ANY}
	main
feature {}
	iu:IU

feature{ANY}

main(i:IU) is
do
	iu := i
	io.put_string("%N ------- Tests unitaires de la classe ADMIN ------- %N")
	io.put_string("Test n°1%N")
	cas11
	io.put_string("Test n°2%N")
	cas21
--	cas22 -- Assertion Violated
	io.put_string("%N ------- Fin des tests unitaires de la classe ADMIN ------- %N")
end -- main

--test n°1 - make_from_user

cas11 is
local
	u : USER
	a : ADMIN
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	create a.make_from_user(u)

	assert := a.is_equal(u)	

	if assert = True then
		io.put_string("     Cas n°1.1 : réussite%N")
	else
		io.put_string("     Cas n°1.1 : échec%N")
	end
end

cas21 is
local
	u : USER
	a : ADMIN
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	create u.make("e130159c", "Eflamm", "Ollivier", mt)
	create a.make_from_user(u)

	a.ajouteruser(u)
	assert := mt.getusers.item(1) /= Void
	a.supprimeruser(u)
	assert := assert and mt.getusers.item(1) = Void

	if assert = True then
		io.put_string("     Cas n°2.1 : réussite%N")
	else
		io.put_string("     Cas n°2.1 : échec%N")
	end
end

cas22 is
local
	a1, a2 : ADMIN
	mt : MEDIATHEQUE
	assert : BOOLEAN
do
	assert := False
	create mt.make(5,30)
	create a1.make("e130159c", "Eflamm", "Ollivier", mt)
	create a2.make("c951031e", "Mmalfe", "Reivillo", mt)
	mt.ajouteruser(a1)
	a2.supprimeruser(a1)

	io.put_string("     Cas n°2.2 : échec%N")
end




end -- class TESTADMIN
