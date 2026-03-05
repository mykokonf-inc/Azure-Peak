// WHISPER OF FEVER - Disease compendium book for physicians and plaguebearers

/obj/item/book/rogue/disease_compendium
	parent_type = /obj/item/recipe_book
	name = "Whisper of Fever"
	desc = "A weathered folio with a dark violet cover. Its pages detail symptoms, stages, and treatments for the many diseases that afflict the people of Psydonia. It smells of bitter herbs and old parchment."
	icon = 'icons/obj/disease_compendium.dmi'
	icon_state = "curebook_0"
	base_icon_state = "curebook"
	open = FALSE
	current_category = "All"
	var/bg_rsc = 'html/disease_compendium_bg.png'
	var/bg_name = "disease_compendium_bg.png"
	slot_flags = ITEM_SLOT_HIP

	types = list(
		/datum/book_entry/disease_compendium/preface,
		/datum/book_entry/disease_compendium/nature,
		/datum/book_entry/disease_compendium/plague,
		/datum/book_entry/disease_compendium/vision_rot,
		/datum/book_entry/disease_compendium/ash_blight,
		/datum/book_entry/disease_compendium/blood_rot,
		/datum/book_entry/disease_compendium/grime_flu,
		/datum/book_entry/disease_compendium/flash_frenzy,
		/datum/book_entry/disease_compendium/derma_tick,
		/datum/book_entry/disease_compendium/flu,
		/datum/book_entry/disease_compendium/conclusion,
	)

/obj/item/book/rogue/disease_compendium/New()
	. = ..()
	update_icon()

/obj/item/book/rogue/disease_compendium/generate_categories()
	categories = list("All") // Reset and add default

	// Gather categories from recipes themselves
	for(var/atom/path as anything in types)
		if(is_abstract(path))
			// Handle abstract types
			for(var/atom/sub_path as anything in subtypesof(path))
				if(is_abstract(sub_path))
					continue

				var/category = get_recipe_category(sub_path)
				if(category && !(category in categories))
					categories += category
		else
			// Handle non-abstract types directly
			var/category = get_recipe_category(path)
			if(category && !(category in categories))
				categories += category

/obj/item/book/rogue/disease_compendium/attack_self(mob/user)
	if(!open)
		// Toggle open state
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
		update_icon()
		user.update_inv_hands()
		return
	. = ..() // Open the recipe book UI
	user.update_inv_hands()

/obj/item/book/rogue/disease_compendium/rmb_self(mob/user)
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	update_icon()
	user.update_inv_hands()
	return

/obj/item/book/rogue/disease_compendium/update_icon()
	icon_state = "[base_icon_state]_[open]"

/obj/item/book/rogue/disease_compendium/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client

	user << browse_rsc(bg_rsc, bg_name)

	var/html = {"
		<!DOCTYPE html>
		<html lang=\"en\">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>

		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&family=Cinzel:wght@600&display=swap');
			body {
				font-family: 'Cinzel', serif;
				font-size: 1em;
				text-align: center;
				margin: 20px;
				color: #000000;
				background-color: rgb(31, 20, 24);
				background-image: url('[bg_name]');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
			h1, h2, h3 {
				font-family: 'Cinzel', serif;
				color: #000000;
				text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.6);
			}
			h1 {
				font-size: 2.2em;
				margin-bottom: 20px;
			}
			h2 {
				font-size: 1.8em;
				margin-bottom: 15px;
			}
			h3 {
				font-size: 1.3em;
				color: #000000;
			}
			.recipe-title {
				font-size: 2em;
				margin-bottom: 15px;
				border-bottom: 1px solid #3e2723;
				padding-bottom: 5px;
				color: #d8b5e6;
			}
			.book-content {
				display: flex;
				height: 85%;
			}
			.sidebar {
				width: 30%;
				padding: 10px;
				border-right: 2px solid #3e2723;
				overflow-y: auto;
				max-height: 600px;
			}
			.main-content {
				width: 70%;
				padding: 10px;
				overflow-y: auto;
				max-height: 600px;
				text-align: left;
			}
			.categories {
				margin-bottom: 15px;
			}
			.category-btn {
				margin: 2px;
				padding: 5px;
				background-color: #d2b48c;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: 'Cinzel', serif;
			}
			.category-btn.active {
				background-color: #6a2b7a;
				color: #ffffff;
			}
			.search-box {
				width: 90%;
				padding: 5px;
				margin-bottom: 15px;
				border: 1px solid #3e2723;
				border-radius: 5px;
				font-family: 'Cinzel', serif;
			}
			.recipe-list {
				text-align: left;
			}
			.recipe-link {
				display: block;
				padding: 5px;
				color: #000000;
				text-decoration: none;
				border-bottom: 1px dotted #d2b48c;
			}
			.recipe-link:hover {
				background-color: rgba(210, 180, 140, 0.3);
			}
			.recipe-content {
				padding: 10px;
			}
			.back-btn {
				margin-top: 10px;
				padding: 5px 10px;
				background-color: #d2b48c;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: 'Cinzel', serif;
			}
			.no-matches {
				font-style: italic;
				color: #8b4513;
				padding: 10px;
				text-align: center;
				display: none;
			}
			table {
				margin: 10px auto;
				border-collapse: collapse;
			}
			table, th, td {
				border: 1px solid #3e2723;
			}
			th, td {
				padding: 8px;
				text-align: left;
			}
			th {
				background-color: rgba(210, 180, 140, 0.3);
			}
			.hidden {
				display: none;
			}
		</style>
	
		<body>
			<h1>Whisper of Fever</h1>
	
			<div class='book-content'>
				<div class='sidebar'>
					<input type='text' class='search-box' id='searchInput'
						placeholder='Search sections...' value='[search_query]'>
	
					<div class='categories'>
	"}

	for(var/category in categories)
		var/active_class = category == current_category ? "active" : ""
		html += "<button class='category-btn [active_class]' onclick=\"location.href='byond://?src=\ref[src];action=set_category&category=[url_encode(category)]'\">[category]</button>"

	html += {"
					</div>

					<div class=\"recipe-list\" id=\"recipeList\">
	"}

	for(var/atom/path as anything in types)
		if(is_abstract(path))
			var/list/sorted_types = sortNames(subtypesof(path))
			for(var/atom/sub_path as anything in sorted_types)
				if(is_abstract(sub_path))
					continue
				if(!sub_path.name)
					continue

				if(ispath(sub_path, /datum/crafting_recipe))
					var/datum/crafting_recipe/recipe = sub_path
					if(initial(recipe.hides_from_books))
						continue
				if(ispath(sub_path, /datum/anvil_recipe))
					var/datum/anvil_recipe/recipe = sub_path
					if(initial(recipe.hides_from_books))
						continue

				var/recipe_name = initial(sub_path.name)

				var/should_show = TRUE
				if(current_category != "All")
					var/category = get_recipe_category(sub_path)
					if(category != current_category)
						should_show = FALSE

				var/display_style = should_show ? "" : "display: none;"

				html += "<a class='recipe-link' href='byond://?src=\ref[src];action=view_recipe&recipe=[sub_path]' style='[display_style]'>[recipe_name]</a>"
		else
			var/recipe_name = initial(path.name)

			var/should_show = TRUE
			if(current_category != "All")
				var/category = get_recipe_category(path)
				if(category != current_category)
					should_show = FALSE

			var/display_style = should_show ? "" : "display: none;"

			html += "<a class='recipe-link' href='byond://?src=\ref[src];action=view_recipe&recipe=[path]' style='[display_style]'>[recipe_name]</a>"

	html += {"
						<div id=\"noMatchesMsg\" class=\"no-matches\">No matching entries found.</div>
					</div>
				</div>

				<div class=\"main-content\" id=\"mainContent\">
	"}

	if(current_recipe)
		// For book entries, use inner_book_html without duplicating the title
		if(ispath(current_recipe, /datum/book_entry))
			var/datum/book_entry/entry = new current_recipe()
			html += "<div class='recipe-content'>"
			html += entry.inner_book_html(user)
			html += "</div>"
			qdel(entry)
		else
			html += generate_recipe_html(current_recipe, user)
	else
		html += "<div class='recipe-content'><p>Select an entry to view its description.</p></div>"

	html += {"
				</div>
			</div>

			<script>
				let searchTimeout;
				document.getElementById('searchInput').addEventListener('keyup', function(e) {
					clearTimeout(searchTimeout);

					searchTimeout = setTimeout(function() {
						const query = document.getElementById('searchInput').value.toLowerCase();
						filterEntries(query);
					}, 300);
				});

				function filterEntries(query) {
					const recipeLinks = document.querySelectorAll('.recipe-link');
					let anyVisible = false;

					recipeLinks.forEach(function(link) {
						const recipeName = link.textContent.toLowerCase();
						const matchesQuery = query === '' || recipeName.includes(query);

						if (matchesQuery) {
							link.style.display = 'block';
							anyVisible = true;
						} else {
							link.style.display = 'none';
						}
					});

					const noMatchesMsg = document.getElementById('noMatchesMsg');
					noMatchesMsg.style.display = anyVisible ? 'none' : 'block';

					window.location.replace(`byond://?src=\\ref[src];action=remember_query&query=${encodeURIComponent(query)}`);
				}

				if ("[search_query]" !== "") {
					filterEntries("[search_query]".toLowerCase());
				}
			</script>
		</body>
		</html>
	"}

	return html

/datum/book_entry/disease_compendium
	category = "Diseases"

/datum/book_entry/disease_compendium/preface
	name = "Preface"

/datum/book_entry/disease_compendium/preface/inner_book_html(mob/user)
	return {"
	<h3><center>WHISPER OF FEVER</center></h3><br>
	<i>A Compendium of Diseases and Afflictions<br>
	For physicians, apothecaries, and healers</i><br><br>
	<b>Preface:</b><br><br>
	In the dusty corners of the world, where sunlight barely reaches the ground and shadows dance between ancient stones, disease takes root.
	It whispers its name to the sick, crawls through veins like worms, and devours flesh and mind.
	Disease is not mere discomfort. It is curse, punishment, and trial.<br><br>
	This volume contains knowledge gathered from countless observations of suffering.
	Every page is soaked in the pain of those who fell to these afflictions.
	Study them. Learn the roads of contagion, for only knowledge can resist death.<br><br>
	<i>- Compiled by the Brotherhood of the Black Beak</i>
	"}

/datum/book_entry/disease_compendium/nature
	name = "On the Nature of Disease"

/datum/book_entry/disease_compendium/nature/inner_book_html(mob/user)
	return {"
	<h3><center>On the Nature of Disease</center></h3><br>
	Diseases spread by many paths. Some transfer through touch, others through the air we breathe.
	Still others hide in blood and bodily fluids.<br><br>
	<b>Routes of transmission:</b><br>
	• <b>Contact transmission</b> - by touching the sick or their belongings<br>
	• <b>Airborne transmission</b> - through coughing and breathing<br>
	• <b>Blood transmission</b> - through wounds and cuts<br>
	• <b>Fluid transmission</b> - through saliva, sweat, and other secretions<br><br>
	<b>Protection against infection:</b><br>
	A Physician's Mask provides reliable protection from contact transmission.
	It blocks miasma and protects against direct contaminated contact.
	A simple rag mask also helps, though less effectively.<br><br>
	<b>Disease stages:</b><br>
	Most diseases progress gradually through several stages.
	Early diagnosis and treatment can save a patient's life.
	"}

/datum/book_entry/disease_compendium/plague
	name = "Plague"

/datum/book_entry/disease_compendium/plague/inner_book_html(mob/user)
	return {"
	<h3><center>Plague (The Plague)</center></h3><br>
	<b>Description:</b> The deadliest known pandemic, striking all body systems at once.
	It progresses rapidly and is always fatal without treatment.<br><br>
	<b>Transmission:</b> skin contact, bodily fluids, and infected blood<br><br>
	<b>STAGE I - Incubation:</b><br>
	• Pale blotches appear on the skin<br>
	• Mild malaise and weakness<br>
	• Chills<br>
	• Intermittent coughing<br>
	• The patient may still feel well and miss the danger<br><br>
	<b>STAGE II - Early plague:</b><br>
	• Painful buboes and ulcers appear<br>
	• Fever becomes pronounced<br>
	• Severe weakness; movement becomes difficult<br>
	• Skin gains an earthy-black tint<br>
	• Heavier coughing and periodic vomiting<br>
	• High risk of infecting nearby people through the air<br><br>
	<b>STAGE III - Advanced plague:</b><br>
	• Skin blackens and dies in large areas<br>
	• Open bleeding wounds and ulcers<br>
	• Heavy internal and external bleeding<br>
	• Constant blood vomiting<br>
	• Hallucinations and clouded consciousness<br>
	• Pain becomes nearly unbearable<br><br>
	<b>STAGE IV - Terminal stage:</b><br>
	• LETHAL! The body is overwhelmed by necrosis<br>
	• The patient reeks of decay<br>
	• Seizures and convulsions<br>
	• Organ failure<br>
	• Loss of consciousness<br>
	• Death becomes inevitable<br><br>
	<b>TREATMENT:</b><br>
	Plague requires urgent two-step treatment:<br><br>
	1. <b>Potion: "Plague Cure (bottle)"</b><br>
	   Ingredients:<br>
	   • 5 Gold ore - symbolizes purity<br>
	   • 1 Hypericum - anti-inflammatory<br>
	   • 1 Heart - vital force
	   <br>• 50 units of Water - purification<br>
	   • 1 Glass bottle - vessel<br><br>
	2. <b>Surgical sanitation:</b><br>
	   • After drinking the potion, surgery must be performed<br>
	   • Incision and opening of affected tissue<br>
	   • Cauterization with a hot instrument to stop bleeding and prevent spread<br>
	   • The operation is extremely painful, but necessary<br><br>
	<b>WARNING:</b> Without immediate treatment in stage 4, death is inevitable within minutes. Any delay is lethal!
	"}

/datum/book_entry/disease_compendium/vision_rot
	name = "Vision Rot"

/datum/book_entry/disease_compendium/vision_rot/inner_book_html(mob/user)
	return {"
	<h3><center>Vision Rot (Vision Rot)</center></h3><br>
	<b>Description:</b> A degenerative disease that slowly destroys ocular function.
	Victims suffer periodic episodes of visual loss and distortion.<br><br>
	<b>Transmission:</b> contact with infected biological fluids and direct skin contact<br><br>
	<b>SYMPTOMS:</b><br>
	• Periodic blurring - vision becomes hazy<br>
	• Temporary color loss - the world appears grayscale<br>
	• Episodes of complete blindness, from seconds up to a minute<br>
	• Eye and periocular pain
	<br>• Tearing and purulent discharge
	<br>• Rarely, irreversible eye damage<br><br>
	<b>TREATMENT:</b><br>
	• The disease can resolve naturally; vision returns over time.<br><br>
	<b>SURGICAL TREATMENT:</b><br>
	To speed recovery, eye-cleaning surgery can be performed:<br>
	• Requires a scalpel to carefully open and remove affected tissue<br>
	• Procedure is performed per eye
	• Causes significant pain and can damage vision if done poorly
	• Plan: incision - cleansing - cauterization to stop bleeding
	"}

/datum/book_entry/disease_compendium/ash_blight
	name = "Ash Blight"

/datum/book_entry/disease_compendium/ash_blight/inner_book_html(mob/user)
	return {"
	<h3><center>Ash Blight (Ash Blight)</center></h3><br>
	<b>Description:</b> A contact disease causing painful rash with ashen buildup.
	Victims lose effectiveness due to unbearable itching.<br><br>
	<b>Transmission:</b> contact with infected bodily fluids and skin<br><br>
	<b>SYMPTOMS:</b><br>
	• Skin covered in ashen spots and open ulcers<br>
	• Formation of a foul black crust<br>
	• Unbearable itching - the patient scratches constantly and loses control<br>
	• Scratching tears ulcers open and causes bleeding, risking further infection
	<br>• Risk of secondary infection in open wounds
	<br>• Can spread to nearby people through close contact<br><br>
	<b>TREATMENT:</b><br>
	Surgical sanitation of affected tissue:<br>
	• Incision - careful opening of damaged tissue
	<br>• Cauterization - hot tool cleansing and disinfection
	<br>• Requires scalpel, cautery, holy cross, or another hot instrument
	<br>• Causes severe burns and pain, but is life-saving
	"}

/datum/book_entry/disease_compendium/blood_rot
	name = "Blood Rot"

/datum/book_entry/disease_compendium/blood_rot/inner_book_html(mob/user)
	return {"
	<h3><center>Blood Rot (Blood Rot)</center></h3><br>
	<b>Description:</b> A parasitic blood infection caused by bloodborne parasites that consume contaminated blood from within.<br><br>
	<b>Transmission:</b> blood-leech bites and direct contact with infected blood<br><br>
	<b>EARLY STAGE:</b><br>
	• Skin begins to pale
	<br>• Dark skin spots appear - a sign of infection
	<br>• General weakness and fatigue
	<br>• Periodic nausea and vomiting
	<br>• Throat irritation and occasional cough<br><br>
	<b>ADVANCED STAGE:</b><br>
	• Dark lines become visible under the skin as parasites travel through veins
	<br>• Constant weakness and slowed movement
	<br>• Severe exhaustion; victim may barely walk
	<br>• Frequent vomiting and persistent coughing
	<br>• Intermittent bleeding from nose and mouth, indicating internal damage<br><br>
	<b>TERMINAL STAGE:</b><br>
	• LETHALLY DANGEROUS!
	<br>• Skin darkens unnaturally
	<br>• Body emits a smell of rot as tissues die from within
	<br>• Constant blood vomiting as internal organs fail
	<br>• Periodic massive bleeding
	<br>• Ongoing internal hemorrhage as blood is steadily lost<br><br>
	<b>TREATMENT:</b><br>
	Blood Rot requires a specialized parasite-purge method:<br><br>
	• The patient must be reduced by blood loss to remove most contaminated blood
	<br>• A medicinal leech is then attached to the depleted patient
	<br>• The leech consumes remaining parasites and clears the infection
	<br>• Successful treatment grants full recovery and temporary immunity<br><br>
	<b>DANGER:</b> This method is highly risky. Excessive blood loss can kill the patient before the leech finishes.
	Continuous monitoring is required, along with readiness to restore blood via transfusion or restorative potions.<br><br>
	<b>WARNING:</b> Do not attempt ordinary treatments.
	Only a leech can drain the tainted blood.
	"}

/datum/book_entry/disease_compendium/grime_flu
	name = "Grime-Flu"

/datum/book_entry/disease_compendium/grime_flu/inner_book_html(mob/user)
	return {"
	<h3><center>Grime-Flu (The Grime-Flu)</center></h3><br>
	<b>Description:</b> A common infection that progressively reduces physical function.
	It develops through several stages.<br><br>
	<b>Transmission:</b> contact with bodily fluids and secretions, as well as droplet spread<br><br>
	<b>EARLY STAGE - Incubation:</b><br>
	• Mild malaise and body weakness
	<br>• Subtle symptoms; patient may not notice infection<br><br>
	<b>DEVELOPING STAGE:</b><br>
	• Pronounced weakness and reduced work capacity
	<br>• Coughing that can periodically infect nearby people
	<br>• Headache, blurred and hazy vision
	<br>• Dehydration and thirst
	<br>• <b>Hand weakness</b> - patient may drop held items
	<br><br>
	<b>PROGRESSIVE STAGE:</b><br>
	• Critical weakness; victim struggles to move
	<br>• Acute body pain with periodic health damage
	<br>• Frequent falls from leg weakness
	<br>• Periodic full color loss - the world turns gray
	<br>• Intensified persistent cough<br><br>
	<b>SEVERE FORM:</b><br>
	• Profound physical exhaustion
	<br>• Blood coughing - a dangerous sign
	<br>• Bleeding and internal damage
	<br>• Acute oxygen shortage; victim struggles to breathe
	<br>• Further deterioration may result in death<br><br>
	<b>TREATMENT:</b><br>
	Grime-Flu responds to alchemical treatment:<br><br>
	1. <b>Potion brewed at an alchemy station: "The Grime-Flu cure"</b><br>
	   Ingredients:<br>
	   • 1 Mentha leaf - soothes airways
	   <br>• 1 Hypericum - anti-inflammatory effect
	   <br>• 50 units of clean Water - base
	   <br>• 1 Glass bottle - vessel<br><br>
	<b>Use:</b><br>
	• Patient drinks the potion
	<br>• Disease clears quickly
	<br>• A temporary immunity period follows recovery<br><br>
	<b>NOTE:</b> This is a rare disease curable with a simple potion, without surgery.
	It is recommended to keep a stock in the infirmary for rapid treatment.
	The potion is brewed at an alchemy station and requires Apprentice Alchemy skill.
	"}

/datum/book_entry/disease_compendium/flash_frenzy
	name = "Flash Frenzy"

/datum/book_entry/disease_compendium/flash_frenzy/inner_book_html(mob/user)
	return {"
	<h3><center>Flash Frenzy (Flash Frenzy)</center></h3><br>
	<b>Description:</b> A dangerous mental disorder causing periodic episodes of uncontrollable rage.
	It clouds the mind with fury and bloodlust.<br><br>
	<b>Transmission:</b> contact with infected bodily fluids and skin contact<br><br>
	<b>SYMPTOMS:</b><br>
	• Heightened irritability between episodes
	<br>• Periodic flashes of uncontrollable rage
	<br>• During episodes:
	<br>&nbsp;&nbsp;- Eyes become bloodshot; face contorts in fury
	<br>&nbsp;&nbsp;- Victim attacks indiscriminately in frenzy
	<br>&nbsp;&nbsp;- Judgment is overwhelmed by rage
	<br>&nbsp;&nbsp;- Increased aggression and violence
	<br>&nbsp;&nbsp;- Victim loses self-control
	<br>• Episode duration: about 10 seconds
	<br>• Severe exhaustion follows each episode<br><br>
	<b>DANGER:</b><br>
	This disease is extremely dangerous to both victim and bystanders. During episodes, victims may severely injure themselves or kill others.<br><br>
	<b>TREATMENT:</b><br>
	Flash Frenzy requires sedative therapy:<br><br>
	• At first signs of an episode, the patient must be put to sleep immediately
	<br>• Only a proper sedative can halt disease progression
	<br>• Keeping the patient asleep under sedative effect allows recovery
	<br>• Requires continuous monitoring and repeated sedative administration
	<br>• Without sedative, the illness does not resolve; ordinary rest is ineffective<br><br>
	<b>SEDATIVE RECIPE:</b><br>
	<b>Step 1 - Make alchemical powders (TABLE required)</b><br><br>
	<b>Make "Soporific Dust":</b><br>
	• 1 Valeriana
	<br>• 1 Artemisia
	<br>• Mix on a table → yields 1 Soporific Dust
	<br>• Craft difficulty: low (level 1)<br><br>
	<b>Make "Drowse Dust":</b><br>
	• 1 Atropa
	<br>• 1 Valeriana (second unit)
	<br>• Mix on a table → yields 1 Drowse Dust
	<br>• Craft difficulty: low (level 1)<br><br>
	<b>Step 2 - Brew Sedative in a cauldron (CAULDRON + FIRE required)</b><br><br>
	<b>Cauldron ingredients:</b><br>
	• 1 Soporific Dust
	<br>• 1 Drowse Dust
	<br>• 90-100 units of clean water (fill the cauldron)<br><br>
	<b>Instructions:</b><br>
	• Fill cauldron with water (minimum 30 ounces = 90 units)
	<br>• Light fire under the cauldron
	<br>• Add Soporific Dust
	<br>• Add Drowse Dust
	<br>• Wait for the mixture to brew (requires MASTER alchemy)
	<br>• The smell of "damp roots" indicates completion
	<br>• Collect Sedative (50 units) into a bottle<br><br>
	<b>SEDATIVE USE:</b><br>
	• Patient must consume 20 units for full cure
	<br>• 50 units of Sedative = about 2.5 full treatment courses
	<br>• Sedative automatically puts the patient to sleep when consumed
	<br>• After required dose is consumed, episodes cease and full recovery follows<br><br>
	<b>WARNING:</b> Both powders are MANDATORY. The cauldron will not accept duplicates. This is a potent brew—ensure the sleeping patient is in a safe place.
	"}

/datum/book_entry/disease_compendium/derma_tick
	name = "Derma-Tick"

/datum/book_entry/disease_compendium/derma_tick/inner_book_html(mob/user)
	return {"
	<h3><center>Derma-Tick (Derma-Tick)</center></h3><br>
	<b>Description:</b> A mild parasitic disease caused by microscopic mites that nest under the skin.
	It is one of the most common and relatively safe illnesses.<br><br>
	<b>Transmission:</b> skin contact with an infected person and contact with bodily fluids<br><br>
	<b>SYMPTOMS:</b><br>
	• Agonizing itching lasting about 10 minutes
	<br>• Randomly distributed affected spots
	<br>• Constant urge to scratch exposed skin
	<br>• Minor scratch marks
	<br>• Scratching can spread disease to nearby people
	<br>• Itching periodically worsens and subsides<br><br>
	<b>COURSE AND TREATMENT:</b><br>
	The disease often resolves naturally or can be cured by sleep. Severe complications are uncommon.<br><br>
	<b>PREVENTION:</b><br>
	• Hand and body hygiene reduces infection risk
	<br>• Avoid close contact with infected individuals
	<br>• Washing clothing helps prevent reinfection<br><br>
	<b>NOTE:</b> Though generally safe, persistent itching can exhaust the patient. Isolation is recommended to prevent spread.
	"}

/datum/book_entry/disease_compendium/flu
	name = "Flu"

/datum/book_entry/disease_compendium/flu/inner_book_html(mob/user)
	return {"
	<h3><center>Flu (Flu)</center></h3><br>
	<b>Description:</b> A transmissible viral illness that causes malaise and weakness.
	Common, and usually non-lethal.<br><br>
	<h3><center>!!IMPORTANT!!</center></h3><br>
	<b>Patient isolation is recommended. Grime-Flu can masquerade as common Flu. Use caution!<br><br>
	<b>Transmission:</b> contact with infected bodily fluids and skin contact<br><br>
	<b>EARLY STAGE (first minute):</b><br>
	• Mild malaise and weakness
	<br>• Onset can be easy to miss
	<br>• Mild symptoms often mistaken for fatigue<br><br>
	<b>DEVELOPED STAGE (after one minute):</b><br>
	• Marked overall weakness and reduced productivity
	<br>• Headache and visual disturbance
	<br>• Blurring and dehydration
	<br>• Symptoms become clearly noticeable
	<br>• Periodic focus loss and visual haze<br><br>
	<b>COURSE AND TREATMENT:</b><br>
	Flu may resolve naturally or through sleep. Symptomatic care is usually effective:<br><br>
	• <b>Rest and sleep</b> - primary recovery method
	<br>• <b>Hydration</b> - patient should drink plenty of fluids
	<br>• A rested, hydrated body fights infection faster
	<br>• Additional medication is often unnecessary<br><br>
	<b>NOTE:</b> While Flu is rarely fatal, combined illnesses or weak immunity can make it dangerous.
	Close observation of vulnerable patients is advised.
	"}

/datum/book_entry/disease_compendium/conclusion
	name = "Conclusion"

/datum/book_entry/disease_compendium/conclusion/inner_book_html(mob/user)
	return {"
	<h3><center>Conclusion</center></h3><br>
	<b>General guidance for physicians and healers:</b><br><br>
	• <b>Physician safety</b> - always wear a mask and protect yourself when treating the infected
	<br>• <b>Early diagnosis</b> - the sooner disease is identified, the better recovery chances
	<br>• <b>Patient isolation</b> - prevent spread among healthy populations
	<br>• <b>Supply readiness</b> - keep herbs, potions, and surgical tools stocked
	<br>• <b>Continuous study</b> - learn every section of this tome for rapid identification
	<br><br>
	<b>Healing plants and substances:</b><br>
	• <b>Hypericum</b> - key anti-inflammatory ingredient for Plague and Grime-Flu
	<br>• <b>Mentha</b> - soothes airways; core ingredient for fever remedies
	<br>• <b>Gold ore</b> - purifying symbolism in advanced potion craft
	<br>• <b>Heart</b> - source of vital force for complex elixirs<br><br>
	<b>Physician tools:</b><br>
	• <b>Scalpel</b> - essential for all surgical procedures
	<br>• <b>Cautery</b> - to stop bleeding and disinfect wounds
	<br>• <b>Holy Cross</b> - alternate heat source; may substitute cautery
	<br>• <b>Leech</b> - unique treatment tool for Blood Rot<br><br>
	<i>Remember: knowledge is your greatest weapon against disease and death. Ignorance buries patients.
	Be vigilant, methodical, and relentless in the fight against infection.</i><br><br>
	<center>- End of this disease tome -</center>
	"}

