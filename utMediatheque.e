class UTMEDIATHEQUE

creation{ANY}
	main

feature{}
	iu:IU

feature{ANY}

main(i:IU) is
do
	iu := i
	iu.put_centered_string("Tests unitaires de la classe MEDIATHEQUE", '*')
	test_mediatheque
	iu.put_centered_string("Fin des tests unitaires de la classe MEDIATHEQUE", '*')
end

test_mediatheque is
local
	m:MEDIATHEQUE
	assert:BOOLEAN
	uts:ARRAY[UTILISATEUR]
	u:UTILISATEUR
do
	create u.init("rdel", "Robin", "Delaporte", False)
	create m.init("","")
	uts:= m.get_gestion_utilisateur.get_lesutilisateurs
	uts.add_last(u)
	m.get_gestion_utilisateur.set_lesutilisateurs(uts)
	m.init("anabol","Bolivar")
	assert := m.get_gestion_media /= Void and m.get_gestion_utilisateur /= Void and m.get_gestion_emprunt /= Void
	if(assert) then
		io.put_string("Test médiathèque: OK")
	else
		io.put_string("Test médiathèque: KO")
	end
end

end -- class UTMEDIATHEQUE
