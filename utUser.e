class UTUSER

creation{ANY}
	main
feature {}
	iu:IU

feature{ANY}

main(i:IU) is
do
	iu := i
	iu.put_centered_string("Tests unitaires de la classe UTILISATEUR", '*')
	test_integrite
	cas_ajout_liste
	iu.put_centered_string("Fin des tests unitaires de la classe UTILISATEUR", '*')
end



test_integrite is
local
	u : UTILISATEUR
	assert : BOOLEAN
do
	assert := False
	create u.init("rdel", "Robin", "Delaporte", False)
	assert := u.get_id.is_equal("rdel") and u.get_prenom.is_equal("Robin") and u.get_nom.is_equal("Delaporte") and u.get_isadmin = False
	if assert = True then
		io.put_string("Test ajout utilisateur : OK%N")
	else
		io.put_string("Test ajout utilisateur : KO%N")
	end
	u.set_isadmin(True)
	assert := assert and u.get_isadmin
	if assert = True then
		io.put_string("Test changemetn type : OK%N")
	else
		io.put_string("Test changemetn type : KO%N")
	end
end

cas_ajout_liste is
local
	u : UTILISATEUR
	m : MEDIATHEQUE
	assert : BOOLEAN
do
	create m.init("","")
	create u.init("rdel", "Robin", "Delaporte", False)
	m.get_gestion_utilisateur.get_lesutilisateurs.add_last(u)
	assert := m.get_gestion_utilisateur.recherche("rdel", "id").count > 1
	if assert = True then
		io.put_string("Test ajout utilisateur dans la médiathèque et recherche : OK%N")
	else
		io.put_string("Test ajout utilisateur dans la médiathèque et recherche : KO%N")
	end
end

end -- class utUser
