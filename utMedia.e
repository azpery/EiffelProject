class UTMEDIA

creation{ANY}
	main

feature{ANY}
main(iu:IU) is
	local
		d1,d2:DVD
		l1,l2:LIVRE
		assert:BOOLEAN
	do
		assert := True
		iu.put_centered_string("Tests unitaires de la classe MEDIA", '*')
		create d1.init("Donnie Darko", "2001", "Richard Kelly", "DVD")
		if( d1.get_titre.is_equal("Donnie Darko") and d1.get_annee.is_equal("2001") and d1.get_type.is_equal("DVD") and d1.get_realisateur.is_equal("Richard Kelly") )then
			io.put_string("Ajout du premier DVD: OK%N")
		else
			io.put_string("Ajout du premier DVD: KO%N")
			assert:=False
		end
		create d2.init("Donnie Darko", "2001", "Richard Kelly", "DVD")
		if( d2.get_titre.is_equal("Donnie Darko") and d2.get_annee.is_equal("2001") and d2.get_type.is_equal("DVD") and d2.get_realisateur.is_equal("Richard Kelly") )then
			io.put_string("Ajout du second DVD: OK%N")
		else
			io.put_string("Ajout du second DVD: KO%N")
			assert:=False
		end
		d1.add_acteur("Jake Gyllenhaal")
		if(d1.acteur_contains("Jake Gyllenhaal"))then
			io.put_string("Ajout d'un acteur: OK%N")
		else
			io.put_string("Ajout d'un acteur: KO%N")
			assert:=False
		end
		if(d1.is_equals(d2))then
			io.put_string("Test egalité entre deux dvd: OK%N")
		else
			io.put_string("Test egalité entre deux dvd: KO%N")
			assert:=False
		end


		create l1.init("Les fourmis", "Bernard Werber", 0)
		create l2.init("Les fourmis", "Bernard Werber", 0)
		if(l1.get_auteur.is_equal("Bernard Werber") and l1.get_titre.is_equal("Les fourmis") and l1.is_equals(l2))then
			io.put_string("Création des deux livres: OK%N")
			io.put_string("Test egalité entre deux livres: OK%N")
		else
			io.put_string("Test egalité entre deux livres: KO%N")
			assert:=False
		end
		iu.put_centered_string("Fin des tests unitaires de la classe MEDIA", '*')
		
	end

end -- class UTMEDIA
