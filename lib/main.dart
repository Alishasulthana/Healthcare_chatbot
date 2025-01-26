import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

enum Messagetype {
  user,
  bot,
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(
    Duration(seconds: 5),
  );
  FlutterNativeSplash.remove();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HealthcareChatbot(),
    );
  }
}

class HealthcareChatbot extends StatefulWidget {
  const HealthcareChatbot({super.key});

  @override
  _HealthcareChatbotState createState() => _HealthcareChatbotState();
}

class _HealthcareChatbotState extends State<HealthcareChatbot> {
  late FlutterTts flutterTts;
  late stt.SpeechToText speech;
  bool isListening = false;
  String recognizedText = '';
  String message = '';
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    speech = stt.SpeechToText();

    // Initialize speech-to-text
    speech.initialize().then((_) {
      setState(() {});
    });
  }

  // Function to start Speech-to-Text
  void startListening() async {
    setState(() {
      isListening = true;
    });
    await speech.listen(onResult: (result) {
      setState(() {
        recognizedText = result.recognizedWords;
      });
    });
  }

  // Function to stop listening
  void stopListening() {
    setState(() {
      isListening = false;
    });
    speech.stop();
    // Add the user's message to chat
    addMessage(recognizedText, Messagetype.user);
    // Process the message and get response
    CheckSymptoms(recognizedText);
  }

  // Function to convert text to speech
  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  // Function to add messages to the chat list
  void addMessage(String text, Messagetype type) {
    setState(() {
      messages.add({
        "message": text,
        "isUser": type == Messagetype.user,
      });
    });
  }

  // Basic symptom checking (expand with real API or logic)
  void CheckSymptoms(String symptomsInput) {
    String response;
    if (symptomsInput.contains('fever')) {
      response = '''
    Symptoms of Fever:
      Chills and shivering
      Sweating
      Fatigue and weakness
      Headache
      Body aches and muscle pain
    Medications:
      Brufen
      paracetamol
      Aspirin (for adults)
      Diclofenac
      Dolo-650
      Sinarest
      T-Minic Syrup (for kids)
    Natural Remedies:
      hydrated: Drink water, coconut water, or ORS to prevent dehydration
      Herbal teas: Ginger, chamomile, or peppermint tea can help. Add honey for an immune boost   
    Dietary Tips:
      Eat light, easily digestible foods such as soups, boiled vegetables, fruits, and rice porridge
      Avoid fried, spicy, or oily foods
      Include vitamin C-rich foods such as oranges, lemons, and berries
    Prevention Tips:
      Avoid strenuous activities
      Rest is crucial
      Apply a cool, damp cloth to the forehead to reduce temperature
      Wear light, breathable clothing
    When to See a Doctor:
      Fever lasts more than 3 days
      Temperature exceeds 103°F (39.4°C)
      Symptoms like difficulty breathing, persistent vomiting, seizures, or severe pain develop
''';
    } else if (symptomsInput.contains('headache')) {
      response = '''
    Symptoms of Headache:
      Pain in the head, temples, or forehead
      Pressure or tightness in the head
      Sensitivity to light or sound
      Nausea or dizziness (in severe cases)
    Medications:
      Paracetamol: every 4-6 hours
      Ibuprofen: every 4-6 hours
      Aspirin: every 4-6 hours (not for children under 18)
      Naproxen: every 12 hours
      Diclofenac: daily in divided doses (consult a doctor for specifics)
      Sumatriptan (for migraines): as a single dose, may repeat after 2 hours
      Caffeine-containing pain relievers: Combination of acetaminophen, aspirin, and caffeine (e.g., Excedrin Migraine) for tension or migraine headaches
    Natural Remedies:
      Stay hydrated: Drink plenty of water to prevent dehydration
      Cold/Hot compress: Apply to the forehead, neck, or temples for relief
      Ginger tea: Reduces inflammation and eases nausea
      Peppermint oil massage: Apply to temples for cooling relief
    Dietary Tips:
      Avoid caffeine, alcohol, and processed foods
      Eat magnesium-rich foods such as spinach, almonds, and avocado
      Have balanced meals to avoid low blood sugar
    Prevention Tips:
      Maintain regular sleep and meal schedules
      Reduce screen time and take breaks
      Practice relaxation techniques like yoga or meditation
      Avoid known headache triggers such as strong odors or bright lights
    When to See a Doctor:
      Headache persists for more than 3 days
      Severe or sudden headache
      Associated with symptoms like vision issues, confusion, weakness, or fever
      Occurs after a head injury
''';
    } else if (symptomsInput.contains('cold')) {
      response = '''
    Symptoms of Cold:
      Runny or stuffy nose
      Sneezing and coughing
      Sore throat
      Mild headache
      Fatigue or tiredness
      Mild fever (occasionally)
    Medications & Dosage:
      Crocin
      Brufen
      Benadryl
      D-Cold
      Sinarest
      Cetrizine
      Coldact
      Nasal drops/spray (e.g., Otrivin, Nasivion, Dr. Reddy's Nasal Drops): 1-2 sprays/drops in each nostril every 4-6 hours (for blocked or runny nose)
      Note: Use nasal decongestants for no more than 3 days to avoid rebound congestion
    Natural Remedies:
      Stay hydrated: Drink water, warm teas, or broths
      Gargle saltwater: Helps soothe sore throat
      Honey and lemon: Soothes throat and boosts immunity
      Steam inhalation: Helps clear nasal congestion
    Dietary Tips:
      Eat warm, light foods like soups and broths
      Avoid dairy if it worsens mucus production
      Include vitamin C-rich foods such as citrus fruits and bell peppers
    Prevention Tips:
      Wash hands regularly
      Avoid close contact with infected individuals
      Rest and get enough sleep to support the immune system
    When to See a Doctor:
      Symptoms persist for more than 10 days
      Severe symptoms like difficulty breathing or chest pain occur
      Fever exceeds 101°F (38.3°C) or doesn't improve with medication
 ''';
    } else if (symptomsInput.contains('cough')) {
      response = '''
    Symptoms of Cough:
      Persistent dry or wet (productive) cough
      Sore throat
      Mucus (clear, yellow, green) with wet cough
      Difficulty breathing (in severe cases)
      Chest discomfort
    Medications & Dosage:
      Dextromethorphan: for dry cough
      Bromhexine: to loosen mucus in wet cough
      Cipla's Ascoril: for both dry and wet cough
      Benadryl: for dry cough and sore throat
      Mucolite: to reduce mucus in wet cough
      Linctus: 1-2 teaspoons 2-3 times a day (for soothing dry cough)
      Gokof: for dry cough
      Tussin: for dry cough
      Corex: for dry or persistent cough
      Syrup Mucolite: 5-10 ml 2-3 times daily (for wet cough and mucus clearance)
    Natural Remedies:
      Honey and lemon: Soothes throat and reduces cough
      Ginger tea: Helps in reducing coughing and soothing the throat
      Steam inhalation: Loosens mucus and eases congestion
      Warm saltwater gargle: Soothes a sore throat and reduces irritation
    Dietary Tips:
      Drink warm liquids like tea, broths, or honey with warm water
      Avoid dairy if it worsens mucus production (especially in wet cough)
      Eat light, non-spicy foods to avoid further irritation
    Prevention Tips:
      Stay hydrated to keep the throat moist
      Avoid irritants like smoke, dust, and pollution
      Rest and get enough sleep to support recovery
    When to See a Doctor:
      Cough lasts for more than 3 weeks
      Severe difficulty breathing or chest pain occurs
      High fever or blood in mucus
      ''';
    } else if (symptomsInput.contains('cough')) {
      response = '''
    Symptoms of Heartburn:
      Burning sensation in the chest or throat, typically after eating
      Sour or bitter taste in the mouth
      Pain that worsens when lying down or bending over
      Chronic cough, hoarseness, or sore throat in persistent cases
      Difficulty swallowing or a lump-like sensation in the throat
    Medications for Heartburn:
      Antacids: Rolaids, Maalox, Mylanta, Alka-Seltzer
      Zantac (Ranitidine)*, Pepcid, Tagamet (*Note: Zantac may not be available in some countries due to safety concerns)
      Proton Pump Inhibitors (PPIs): Prilosec, Prevacid, Nexium, Protonix
      Prokinetics: Reglan, Motilium
      Alginates: Gaviscon, Acidex
    Home Remedies for Heartburn:
      Baking soda: Dissolve 1/2 teaspoon in a glass of water for quick relief
      Apple cider vinegar: Mix 1-2 teaspoons in water (use cautiously; it may worsen symptoms for some)
      Ginger tea: Soothes the stomach and reduces acid production
      Aloe vera juice: Drink 1/4 cup to cool and soothe irritation
      Chewing gum: Increases saliva production, neutralizing stomach acid
    Prevention Tips:
      Avoid trigger foods (spicy, fatty, fried, acidic, chocolate, caffeine, alcohol)
      Eat smaller meals and avoid overeating
      Don't lie down for 2-3 hours after eating
      Elevate the head of your bed by 6-8 inches
      Maintain a healthy weight to reduce abdominal pressure
      Quit smoking, as it weakens the lower esophageal sphincter
    When to See a Doctor:
      Heartburn occurs more than twice a week or persists despite medications
      Symptoms interfere with daily life
      You have difficulty swallowing or feel like food is stuck in your throat
      You experience unexplained weight loss
      Vomiting blood or black, tarry stools occur
      Severe chest pain occurs, especially with shortness of breath or arm pain (rule out heart attack)
''';
    } else if (symptomsInput.contains('menstrual pain')) {
      response = '''
    Symptoms of Menstrual Cramps:
      Throbbing or cramping pain in the lower abdomen
      Pain that may radiate to the lower back and thighs
      Nausea, vomiting, or diarrhea in some cases
      Fatigue and general discomfort
      Symptoms typically begin 1-2 days before or during menstruation and last 1-3 days
    Medications for Menstrual Cramps:
      Over-the-counter (OTC) pain relievers: Ibuprofen (Advil, Motrin), Naproxen (Aleve)
      Usage: Take at the first sign of cramps and continue as needed (follow dosage instructions)
      Antispasmodic tablets: Cyclopam, Meftal Spas
      Usage: Effective for relieving severe cramping caused by muscle spasms
      Aspirin (Disprin), Acetaminophen (Paracetamol, Tylenol) for mild pain
      Prescription medications: Birth control pills to regulate periods and reduce cramping (consult a doctor)
      Home Remedies for Menstrual Cramps:
    Heat therapy:
      Apply a heating pad or hot water bottle to the lower abdomen
      Take a warm bath to relax muscles
      Herbal teas:Ginger tea: Reduces inflammation and relieves pain
      Chamomile tea: Soothes cramps and promotes relaxation
      Light exercise:Stretching, yoga, or a short walk can improve blood flow and ease discomfort
      Massage:Gently massage the lower abdomen in circular motions to relieve pain
      Hydration:Drink plenty of water to reduce bloating, which can worsen cramps
      Dietary adjustments:Increase intake of magnesium-rich foods such as bananas, nuts, and leafy greens
      Avoid caffeine, alcohol, and salty foods during your period
      Prevention Tips:Exercise regularly to improve circulation and reduce cramp intensity
      Maintain a healthy, balanced diet with plenty of fruits, vegetables, and whole grains
      Reduce stress through relaxation techniques such as yoga, meditation, or deep breathing
      Track your menstrual cycle to prepare for cramps in advance and start pain relief early
    When to Seek a Doctor:
      Cramps are so severe that they disrupt daily activities
      Pain doesn't improve with OTC medications or home remedies
      Periods are excessively heavy, irregular, or prolonged
      New or worsening pain appears after years of mild or no cramps
      Symptoms include fever, foul-smelling discharge, or unusual pelvic pain (could indicate an infection or other conditions like endometriosis or fibroids)
      If you’re on medications that affect hormones, like treatments for PCOS or endometriosis, follow your doctor’s advice for use during your cycle
 ''';
    } else if (symptomsInput.contains('stomach pain')) {
      response = '''
    Symptoms:
      Frequent, loose, or watery stools
      Abdominal cramps or pain
      Bloating or feeling of fullness
      Urgency to have a bowel movement
      Possible nausea, vomiting, or fever in some cases
    Medications:
      Anti-motility agents (slow down bowel movements): Loperamide (Imodium), Diphenoxylate (Lomotil)
      Usage: Helps reduce the frequency of diarrhea
      Oral Rehydration Solutions: Pedialyte, Oral Rehydration Salts (ORS)
      Usage: Replaces lost fluids and electrolytes to prevent dehydration
      Probiotics (restore healthy gut bacteria): Lactobacillus (Acidophilus), Saccharomyces boulardii
      Usage: Helps improve gut health and may reduce the duration of diarrhea
      Antibiotics (only when prescribed for bacterial infections): Ciprofloxacin, Metronidazole
      Usage: Used only when necessary, based on doctor's advice
      Home Remedies:
      Clear liquids: Drink clear fluids like water, broth, and herbal teas to stay hydrated
      Bananas: Easy on the stomach and help replace lost potassium
      Rice, applesauce, and toast (BRAT diet): Bland foods that are gentle on the digestive system
      Ginger tea: Reduces nausea and settles the stomach
      Yogurt: Contains probiotics that may help restore gut health
    Prevention Tips:
      Wash hands regularly, especially before meals
      Avoid contaminated food and water (especially when traveling)
      Be cautious with dairy or fatty foods if you’re prone to digestive issues
      Maintain proper hydration during illness to avoid dehydration
    When to Seek a Doctor:
      Stomach pain lasts more than 2 days or is accompanied by a high fever
      Blood or mucus is present in stools
      Severe dehydration signs, such as dry mouth, dizziness, or reduced urine output
      Stomach pain occurs in infants, elderly, or individuals with weakened immune systems
      Stay hydrated and take care! Let me know if you need any more help.
''';
    } else if (symptomsInput.contains('constipation')) {
      response = '''
    Symptoms of Constipation
      Difficulty or infrequent bowel movements (less than 3 times a week)
      Hard, dry, or lumpy stools
      Straining during bowel movements
      A feeling of incomplete evacuation
      Abdominal bloating or discomfort
    Medications & Dosage
      Lactulose Syrup (Osmotic Laxative): 10-20 ml daily (can be adjusted based on response)
      Isabgol (Psyllium Husk): 1-2 teaspoons mixed with warm water or milk before bedtime
      Dulcolax (Bisacodyl): 5-10 mg orally once daily before bed (for occasional use)
      Cremaffin (Milk of Magnesia): 10-20 ml before bedtime (for relief from mild constipation)
      Senna Tablets (Stimulant Laxative): 1-2 tablets once daily before bed (short-term use only)
    Natural Remedies
      Hydration: Drink 8-10 glasses of water daily to soften stools
      Fiber-rich diet: Include whole grains, fruits (like papaya, prunes, and apples), and vegetables
      Warm lemon water: Stimulates bowel movements when taken in the morning
      Castor oil: 1-2 teaspoons on an empty stomach (short-term use only)
      Aloe vera juice: 1-2 tablespoons mixed with water to promote digestion and bowel movement
    Dietary Tips
      Avoid processed and junk foods
      Limit intake of dairy products if they worsen symptoms
      Add natural probiotics like yogurt or fermented foods to your diet
      Include flaxseeds or chia seeds to promote digestion
    Prevention Tips
      Exercise regularly to stimulate bowel movements
      Maintain a consistent eating and bathroom schedule
      Avoid overuse of laxatives to prevent dependency
      Manage stress, as it can contribute to constipation
    When to See a Doctor
      Constipation lasts more than 2 weeks despite treatment
      Severe abdominal pain, vomiting, or blood in stools occurs
      Unexplained weight loss accompanies constipation
''';
    } else if (symptomsInput.contains('gas')) {
      response = '''
    Symptoms of Gas
      Bloating or fullness in the abdomen
      Passing gas (flatulence)
      Belching or burping
      Abdominal discomfort or cramping
      Gurgling or rumbling sounds in the stomach
    Medications & Dosage
      Simethicone (Gas-X): 40-125 mg after meals and at bedtime (as needed)
      Digene (Antacid): 1-2 teaspoons after meals or as directed by a doctor
      Pudina Hara (Ayurvedic Remedy): 1-2 capsules after meals to relieve gas and indigestion
      Activated Charcoal Tablets: 500-600 mg before meals (to absorb excess gas)
      Pantoprazole or Ranitidine (Acid Reducers): 20-40 mg daily for gas related to acidity (consult a doctor)
    Natural Remedies
      Ginger tea: Brew fresh ginger slices in hot water to relieve bloating and promote digestion
      Ajwain (Carom Seeds): Chew 1 teaspoon with a pinch of salt for instant relief
      Peppermint tea: Helps relax intestinal muscles and reduce gas
      Warm lemon water: Stimulates digestion and reduces bloating when taken in the morning
      Fennel seeds: Chew 1 teaspoon after meals to aid digestion and reduce flatulence
    Dietary Tips
      Avoid carbonated drinks and artificial sweeteners
      Limit gas-producing foods like beans, lentils, broccoli, and cabbage
      Eat smaller, frequent meals to avoid overloading the stomach
      Avoid lying down immediately after eating
    Prevention Tips
      Chew food thoroughly and eat slowly to reduce swallowed air
      Stay active with regular exercise to promote digestion
      Avoid smoking and chewing gum, which can cause air swallowing
      Drink plenty of water throughout the day to prevent constipation-related gas
    When to See a Doctor
      Persistent or severe abdominal pain with gas
      Unexplained weight loss or blood in stools
      Frequent vomiting or signs of intestinal blockage
''';
    } else if (symptomsInput.contains('indigestion')) {
      response = '''
    Symptoms :-
     Fullness, bloating, heartburn, nausea, burping, sour taste, appetite loss
    Medications :-     
     OTC: Tums,rolaids,mylanta etc..
     Prescription: Stronger PPIs, prokinetics
    Natural Remedies :-
     Herbal teas (ginger, peppermint, chamomile)
     Eat small meals, avoid trigger foods, try probiotics
    Prevention Tips:- 
     Eat slowly, avoid overeating, reduce stress, limit alcohol and caffeine, don’t lie down after eating
    When to See a Doctor:-
     Persistent or severe symptoms, weight loss, difficulty swallowing, black stools, or chest pain
''';
    } else if (symptomsInput.contains('vomitings')) {
      response = '''
    Symptoms of Vomiting
     Nausea
     Forceful expulsion of stomach contents
     Abdominal cramps
     Sweating or dizziness
     Dry mouth or dehydration
     Weakness or fatigue
    Medications
     Over-the-Counter (OTC):
       Dimenhydrinate
       Meclizine
       Pepto-Bismol: For nausea and mild vomiting
     Prescription Medications:
       Ondansetron (Zofran): For severe vomiting
       Metoclopramide: For nausea and delayed stomach emptying
    Natural Remedies
     Hydration: Sip water, clear broths, or Oral Rehydration Solution (ORS)
     Ginger: Ginger tea or ginger candy to reduce nausea
     Mint: Peppermint tea or lozenges to soothe the stomach
     BRAT Diet: Bananas, Rice, Applesauce, Toast to settle the stomach
    Prevention Tips :-
     Avoid overeating or consuming greasy foods
     Stay hydrated, especially during travel or illness
     Eat small, frequent meals instead of large ones
     Avoid strong smells or triggers for nausea
    When to Seek a Doctor :-
     Vomiting lasts more than 24 hours
     Severe dehydration signs (dark urine, no urination, extreme thirst)
     Blood in vomit (coffee-ground appearance)
     High fever or severe abdominal pain
     Vomiting after a head injury
''';
    } else if (symptomsInput.contains('ear infection')) {
      response = '''
    Symptoms: 
      Ear pain
      swelling
      fever
      irritability
      fluid drainage
      hearing loss
    Medications:
      Antibiotics:amoxicillin,azithromycin
      Pain relievers:acetaminophen, ibuprofen
    Natural Remedies:
      Warm compress on the ear
      Garlic oil drops (if not allergic)
    Prevention Tips:
      Practice good hygiene (handwashing)
      Avoid smoke exposure
      Keep vaccinations up to date
    When to Seek a Doctor:
      Severe pain or swelling
      Symptoms persist for more than 2-3 days
      High fever or worsening condition
''';
    } else if (symptomsInput.contains('ear pain')) {
      response = '''
    Symptoms: 
      Earache
      a feeling of fullness
      hearing loss
      ringing in the ear (tinnitus)
    Medications:
      Ear drops:carbamide peroxide
    Natural Remedies:
      Mineral oil or baby oil drops
      Warm water irrigation (with caution)
    Prevention Tips:
      Avoid using cotton swabs in the ear canal
      Clean the outer ear regularly
    When to Seek a Doctor:
      If symptoms persist after home treatment
      If there is pain or significant hearing loss
    ''';
    } else if (symptomsInput.contains('Tinnitus')) {
      response = '''
    Symptoms: 
      Ringing
      buzzing or hissing sound in the ears
      often noticeable in quiet environments
    Medications:
      amitriptyline
      imipramine
      nortriptyline
    Natural Remedies:
      Sound therapy (white noise machines)
      Relaxation techniques (meditation, yoga)
    Prevention Tips:
      Avoid loud noises and wear ear protection
      Manage stress levels
    When to Seek a Doctor:
      If tinnitus affects daily activities
      If accompanied by hearing loss or dizziness
''';
    } else if (symptomsInput.contains('nasal congestion')) {
      response = '''
    Symptoms:
      Difficulty breathing through the nose
      Pressure or fullness in the nose or head
      Reduced sense of smell
    Medications:
      OTC decongestants:pseudoephedrine, oxymetazoline nasal spray
      Saline nasal sprays
    Natural Remedies:
      Steam inhalation
      Warm compress over sinuses
    Prevention Tips:
      Stay hydrated
      Avoid allergens and irritants
    When to Seek a Doctor:
      Congestion persists for more than 10 days
     Severe pain or swelling in the face
''';
    } else if (symptomsInput.contains('nose bleed')) {
      response = '''
    Symptoms:
      Blood dripping or flowing from one or both nostrils
    Medications:
      nasal saline gel 
    Natural Remedies:
      Pinch the soft part of the nose and lean forward
      Apply a cold compress to the nose bridge
    Prevention Tips:
      Avoid picking or blowing your nose too hard
      Keep the nasal passages moist with saline spray
    When to Seek a Doctor:
      Frequent or heavy nosebleeds
      Bleeding that lasts longer than 20 minutes
''';
    } else if (symptomsInput.contains('sore throat')) {
      response = '''
    Symptoms:
      Pain or scratchiness in the throat
      Difficulty swallowing
      Red and swollen tonsils
      White patches on the tonsils
      Swollen lymph nodes in the neck
      Fever
    Medications:
      Over-the-counter pain relievers:acetaminophen or ibuprofen
      Throat lozenges or sprays with numbing agents
    Natural Remedies:
      Gargling with warm salt water
      Drinking warm fluids like herbal teas or broths
      Honey mixed with warm water or tea
    Prevention Tips:
      Wash hands frequently to avoid infections
      Avoid close contact with sick individuals
      Maintain a healthy lifestyle to strengthen the immune system
    When to Seek a Doctor:
      Symptoms persist for more than a few days
      Severe pain or difficulty swallowing
      High fever (over 101°F or 38.3°C)
      Rash or difficulty breathing
''';
    } else if (symptomsInput.contains('dry throat')) {
      response = '''
    Symptoms:
      Scratchy or rough feeling in the throat
      Difficulty swallowing
      A sensation of tightness in the throat
      Increased thirst
    Medications:
      Over-the-counter throat sprays for dryness like 
       Himalaya Herbal   
       Dabur Honitus Throat Spray
       Vicks Cough Drops and Throat Spray
       Dr. Ortho Throat Spray
       Zee Throat Spray
      Saline nasal sprays if nasal passages are dry
         NasoClear
         Himalaya Herbal Healthcare Nasal Spray
         Otrivin Saline Nasal Spray
         Nasaline 
         Sterimar
    Natural Remedies:
      Drinking plenty of fluids
      Using a humidifier to add moisture to the air
      Gargling with salt water or drinking warm teas
    Prevention Tips:
      Stay hydrated, especially in dry environments
      Use a humidifier in your home
      Avoid smoking and exposure to smoke
   When to Seek a Doctor:
      Dry throat persists despite self-care
      Symptoms are accompanied by a severe cough or other respiratory issues
      Signs of dehydration (e.g., dizziness, reduced urination)
''';
    } else if (symptomsInput.contains('allergic reactions')) {
      response = '''
    Symptoms:
      Itchy or scratchy throat
      Sneezing or nasal congestion
      Runny or stuffy nose
      Watery eyes
      Coughing
    Medications:
      Over-the-counter antihistamines:cetirizine, loratadine
      Decongestants for nasal congestion
    Natural Remedies:
      Nasal saline rinses
      Drinking warm herbal teas to soothe the throat
      Honey may help with some allergies
    prevention Tips:
      Identify and avoid known allergens (pollen, dust, pet dander)
      Keep windows closed during high pollen seasons
      Use air purifiers to reduce indoor allergens
    When to Seek a Doctor:
      Severe allergic reaction (e.g., difficulty breathing, swelling of the face or throat)
      symptoms do not improve with over-the-counter medications
      Persistent symptoms affecting daily life
''';
    } else if (symptomsInput.contains('tooth pain')) {
      response = '''
    Symptoms of Tooth Pain
      Tooth sensitivity to hot, cold, or sweet foods
      Visible holes or pits in the teeth
      Toothache, especially when eating or drinking
      Discoloration (brown, black, or white spots) on teeth
      Bad breath or unpleasant taste in the mouth
    Medications & Treatments
      Fluoride Toothpaste:
       Colgate Total Advanced Deep Clean
       Sensodyne Repair and Protect (especially if sensitivity accompanies decay)
       Crest Pro-Health Advanced
       Aquafresh Cavity Protection
       Parodontax Daily Fluoride Toothpaste
      Pain Relievers (Paracetamol or Ibuprofen): For temporary relief from toothache
      Antibiotics (e.g., Amoxicillin): Prescribed in cases of infection (consult a dentist)
      Dental Filling: To repair cavities
      Root Canal Treatment (RCT): For severe decay affecting the tooth's pulp
      Dental Crown: To cover and protect a damaged tooth
    Natural Remedies
      Saltwater Rinse: Gargle with warm saltwater to reduce pain and inflammation
      Clove Oil: Apply directly to the affected tooth for pain relief
      Garlic: Chew or place crushed garlic on the tooth for its antibacterial properties
      Guava Leaves: Chew fresh leaves or boil them to make a mouth rinse
    Prevention Tips
      Brush Twice Daily: Use fluoride toothpaste and a soft-bristled brush
      Floss Regularly: Remove food particles between teeth
      Limit Sugary Foods and Drinks: Avoid candy, soda, and sticky snacks
      Rinse Your Mouth: After meals, especially after consuming sugary items
      Regular Dental Checkups: Visit a dentist every 6 months for cleaning and early detection of issues
    When to See a Dentist
      Persistent toothache or sensitivity
      Visible holes, discoloration, or broken teeth
      Swollen gums, pus, or signs of infection
     Pain that disrupts daily activities
''';
    } else if (symptomsInput.contains('rashes')) {
      response = '''
    Symptoms of Rashes
      Red, itchy, or inflamed skin
      Small bumps, blisters, or scales
      Dry or peeling skin
      Pain, burning, or stinging sensation (in some cases)
      Fluid-filled blisters or crusting (in severe cases)
    Medications
      Cetirizine or Loratadine
      Hydrocortisone Cream:Topical Steroid
      Calamine Lotion: Apply directly for soothing relief from itching and irritation
      Clotrimazole:For fungal rashes like ringworm or athlete’s foot; apply 2–3 times daily
      Neosporin:For infected rashes; apply as directed
    Natural Remedies :-
      Aloe Vera Gel: Apply fresh aloe vera to soothe and cool the rash
      Oatmeal Bath: Add colloidal oatmeal to lukewarm bathwater to relieve itching
      Coconut Oil: Use as a moisturizer for dry or irritated skin
      Chamomile Tea Compress: Soak a cloth in cooled chamomile tea and place it on the rash for relief
      Baking Soda Paste: Mix baking soda with water and apply to the rash to reduce itching and irritation
    Dietary Tips :-
      Stay hydrated to promote skin healing
      Avoid spicy, oily, or processed foods that may aggravate rashes
      Include foods rich in vitamin C (e.g., citrus fruits) and omega-3 fatty acids (e.g., fish, flaxseeds) to reduce inflammation
    Prevention Tips :-
      Avoid Triggers: Identify and avoid allergens (e.g., pollen, specific foods, soaps).
      Wear Loose Clothing: Use soft, breathable fabrics like cotton.
      Moisturize Regularly: Prevent dryness and irritation by using fragrance-free moisturizers.
      Keep Cool: Avoid excessive heat and humidity to prevent sweat rashes.
      Hygiene: Wash skin gently with mild soap and lukewarm water.
    When to See a Doctor :-
      Rash persists for more than a week despite treatment.
      Severe itching, pain, or swelling develops.
      Rash is accompanied by fever, difficulty breathing, or other systemic symptoms.
      Signs of infection (e.g., pus, warmth, redness) appear.
''';
    } else if (symptomsInput.contains('obesity')) {
      response = '''
      Symptoms of Obesity:-
        Increased body weight, often concentrated in the abdomen, hips, or thighs
        Breathlessness, especially during physical activity
        Fatigue or lack of energy
        Snoring or sleep disturbances, such as sleep apnea
        Joint pain or stiffness, especially in the knees, hips, and lower back
        Skin problems, such as rashes or chafing in skin folds
      Medications for Obesity:-
        Orlistat: Reduces fat absorption in the intestines
        Liraglutide: Regulates appetite by acting on brain receptors
        Phentermine-topiramate: Suppresses appetite and increases fullness
        Semaglutide: Helps regulate hunger and food intake
        Bupropion-naltrexone: Helps control cravings and reduce caloric intake
         Note: These medications should only be taken under a doctor's supervision
      Natural Remedies for Obesity
        1. Dietary Changes: Eat a high-fiber diet (vegetables, fruits, whole grains)
          Reduce sugar and processed food intake
          Incorporate healthy fats like nuts, seeds, and avocados
        2. Regular Exercise: Aim for at least 150 minutes of moderate-intensity activity weekly
        3. Herbal Remedies: Green tea for metabolism boosting
          Ginger and lemon water to support digestion
        4. Portion Control: Practice mindful eating to avoid overeating
        5. Stress Management: Techniques like yoga, meditation, or deep breathing help reduce emotional eating
        6. Stay Hydrated: Drink plenty of water to boost metabolism and reduce hunger
      Prevention Tips for Obesity
        1. Maintain a Healthy Diet: Follow a balanced, calorie-conscious diet
        2. Regular Physical Activity: Include cardio, strength
      When to Seek a Doctor for Obesity
        BMI of 30 or higher (obesity classification)
        Related health issues: such as diabetes, hypertension, high cholesterol, or sleep apnea
        Ineffective weight loss: no significant results after several months of diet and exercise
        Emotional concerns: feelings of depression or anxiety related to weight
        Interest in medications or surgery for weight loss
        Pre-existing health conditions that may be affected by obesity
''';
    } else if (symptomsInput.contains('burns')) {
      response = '''
  1. First-Degree Burns (Superficial Burns)
      What It Is: Affects only the outer layer of skin (epidermis)
      Symptoms: Redness, mild swelling, pain, no blisters
      Medications:
      ibuprofen 
      acetaminophen
        Topical ointments like aloe vera gel, 1% hydrocortisone, or antibiotic creams
      Natural Remedies:
        Cool water: Run under cool (not cold) water for 10-15 minutes
        Aloe vera: Apply fresh aloe vera gel to soothe and promote healing
        Honey: Apply raw honey to reduce inflammation and prevent infection
      Prevention:
        Use sunscreen, avoid prolonged sun/heat exposure
      See a Doctor: 
        If covering large areas or on sensitive areas like the face, joints, or genitals
  2. Second-Degree Burns (Partial-Thickness Burns)
      What It Is: Affects the outer layer (epidermis) and part of the dermis
      Symptoms: Blisters, intense pain, swelling, wet/moist skin
      Medications:
        silver sulfadiazine
        ibuprofen
        acetaminophen
      Natural Remedies:
        Cool compresses: Apply cool, damp cloths to soothe pain
        Aloe vera: Use aloe vera gel to promote healing and reduce pain
        Lavender essential oil: Dilute and apply to help reduce pain and promote healing
      Prevention: 
        Use protective gear, handle hot liquids and flames carefully
      See a Doctor: 
        If the burn is larger than 3 inches or on the face, hands, feet, or genitals
  3. Third-Degree Burns (Full-Thickness Burns
      What It Is: Destroys all layers of skin, potentially affecting muscles, bones, and nerves
      Symptoms: White, black, or charred skin; leathery texture; numbness due to nerve damage
      Medications:
        mafenide acetate
        IV fluids and pain management in a hospital
      Natural Remedies:
        While natural remedies are generally not advised for third-degree burns due to the severity, honey may be used under medical supervision for its antibacterial properties
      Prevention: 
        Fire safety, avoid contact with chemicals, electrical sources, and open flames
''';
    } else if (symptomsInput.contains('body pains')) {
      response = '''
   Symptoms: Generalized aching, stiffness, fatigue, and soreness
  Medications:
     Ibuprofen
     naproxen
     Paracetamol
    Muscle Relaxants:
     Cyclobenzaprine (Flexeril)
     Methocarbamol (Robaxin)
     Carisoprodol (Soma)
     Tizanidine (Zanaflex)
    Natural remedies:
     rest
     Heat or cold therapy
     Epsom salt baths
     Gentle stretching and yoga
    Prevention Tips:
     Regular exercise
     Good posture
     Ergonomic workspace setup
     Staying hydrated
    When to Seek a Doctor:
     Severe or persistent pain
     Pain lasting more than a few days
     Pain accompanied by swelling, redness, or fever
     Pain after an injury or trauma
''';
    } else if (symptomsInput.contains('eye flu')) {
      response = '''
    Symptoms:
      Redness in the white part of the eye
      Watery discharge
      Itching or burning sensation
      Swollen eyelids
      Sensitivity to light
      Gritty feeling in the eye
    Medications:
      cetirizine
      loratadine
      Artificial tears:
       Refresh Tears
       Systane
       Blink Tears
       Optive
       TheraTears
    Topical antiviral medications:
      Trifluridine (Viroptic)
    Natural Remedies:
      Warm compresses on the eyes
      Cold compresses to reduce swelling
      Good hygiene practices (wash hands regularly)
      Avoiding eye makeup and contact lenses until healed
    Prevention Tips:
      Wash hands frequently
      Avoid touching the face and eyes
      Do not share towels, pillows, or makeup
      Stay home when infected to prevent spreading
    When to Seek a Doctor:
      Severe pain in the eye
      Changes in vision
      Symptoms lasting more than a week
      Signs of bacterial infection (thick yellow or green discharge)
''';
    } else if (symptomsInput.contains('iron deficiency')) {
      response = '''
    Symptoms:
      Fatigue and weakness
      Pale skin
      Shortness of breath
      Dizziness or lightheadedness
      Cold hands and feet
      Brittle nails
      Headaches
    Medications:
     Iron Supplements:
      Feosol 
      Fer-In-Sol
      Fergon
      Hemocyte 
      Ferrous Fumarate
      Vitamin C: (to enhance iron absorption)
      Ascorbic acid (e.g., Nature’s Bounty Vitamin C, Sundown Naturals Vitamin C)
    Natural Remedies:
      Foods Rich in Iron:
      Red meat, poultry, fish
      Leafy green vegetables (spinach, kale)
      Legumes (beans, lentils)
      Nuts and seeds
      Fortified cereals
      Foods High in Vitamin C: Citrus fruits, strawberries, bell peppers (to improve iron absorption.
    Prevention Tips:
      Consume a balanced diet rich in iron and vitamin C
      Avoid excessive consumption of tea or coffee with meals, as they can inhibit iron absorption
      For vegetarians, ensure intake of iron-rich plant foods and consider pairing them with vitamin C sources
    When to Seek a Doctor:
      Severe fatigue or weakness
      Symptoms of anemia persisting despite dietary changes
      Symptoms worsening or accompanied by chest pain, rapid heartbeat, or shortness of breath
      If you suspect an underlying condition affecting iron absorption (e.g., gastrointestinal issues)
''';
    } else if (symptomsInput.contains('mouth lucers')) {
      response = '''
      Symptoms: Painful sores, redness, swelling, difficulty eating/speaking
    Medications:
      OTC: Antiseptic mouthwash, numbing gels (benzocaine)
      Prescription: Corticosteroid gels, colchicine (severe cases)
      Pain Relief: Paracetamol, ibuprofen
    Natural Remedies:
      Apply honey.
      Rinse with saltwater
      Use aloe vera gel
    Prevention Tips:
      Avoid spicy/acidic foods
      Maintain good oral hygiene
      Stay hydrated and manage stress
    When to See a Doctor:
      Ulcers lasting >2 weeks
      Severe pain or large sores
      Frequent recurrence
      Accompanying fever or difficulty eating
''';
    } else if (symptomsInput.contains('dizziness')) {
      response = '''
    Symptoms:
      Lightheadedness or feeling faint
      Sensation of spinning (vertigo)
      Loss of balance or unsteadiness
      Nausea or vomiting
    Medications:
      For Vertigo: Meclizine (Antivert), Betahistine
      For Nausea: Prochlorperazine, Dimenhydrinate (Dramamine)
      Treat Underlying Conditions: Iron supplements for anemia, antihypertensives for high blood pressure
    Natural Remedies:
      Drink plenty of water to stay hydrated
      Eat small, frequent meals to maintain blood sugar levels
      Practice deep breathing or relaxation techniques
      Use ginger tea for nausea
    Prevention Tips:
      Stay hydrated and avoid skipping meals
      Stand up slowly after sitting or lying down
      Avoid caffeine, alcohol, or tobacco
      Manage stress through exercise or meditation
    When to See a Doctor:
      Dizziness persists or recurs frequently
      Severe symptoms like fainting, chest pain, or difficulty speaking
      Associated with a head injury or neurological symptoms
      Impacts daily activities or quality of life
''';
    } else if (symptomsInput.contains('malnutrition')) {
      response = '''
    Symptoms:
      Fatigue, weakness, or low energy
      Unintended weight loss.
      Dry skin, hair loss, or brittle nails
      Frequent illnesses or slow recovery
      Swollen abdomen, hands, or feet (in severe cases)
    Medications:
      Nutritional Supplements: Multivitamins, iron, calcium, vitamin D, or B12 as needed
      Medical Nutrition Therapy: High-calorie/protein supplements (e.g., Ensure, Pediasure)
      Specific Deficiencies: Iron supplements for anemia, zinc for immune health
    Natural Remedies:
      Consume nutrient-dense foods: eggs, nuts, beans, leafy greens, and fruits
      Use homemade smoothies or soups for easy digestion
      Incorporate healthy fats (avocado, olive oil)
    Prevention Tips:
      Maintain a balanced diet with proteins, carbs, fats, vitamins, and minerals
      Monitor nutritional needs during life stages (e.g., pregnancy, aging)
      Address underlying conditions affecting absorption (e.g., celiac, IBS)
      Educate on proper nutrition and meal planning
    When to See a Doctor:
      Rapid weight loss or persistent fatigue
      Signs of severe deficiency (swollen abdomen, hair thinning)
      Malabsorption symptoms like diarrhea or bloating
      If a chronic condition impacts nutrition
''';
    } else if (symptomsInput.contains('feet cracks')) {
      response = '''
    Symptoms:
      Dry, thickened, or peeling skin on the fee.
      Deep cracks or fissures, sometimes painful
      Redness, itching, or bleeding in severe cases
      Hard, callused areas around heels
    Medications:
      OTC Creams: Urea-based creams (e.g., Eucerin, UreaRepair)
      Moisturizers: Petroleum jelly (Vaseline), lanolin-based products
      Antifungal Creams: For infections, like clotrimazole
    Natural Remedies:
      Soak feet in warm water with Epsom salt or vinegar
      Exfoliate with a pumice stone after soaking
      Apply coconut oil, shea butter, or aloe vera before bed
      Use honey as a natural antibacterial moisturizer
    Prevention Tips:
      Keep feet clean and moisturized daily
      Wear supportive, closed shoes with cushioned soles
      Avoid standing for long periods on hard surfaces
      Stay hydrated to maintain skin elasticity
    When to See a Doctor:
      Cracks are deep, painful, or bleeding
      Signs of infection (redness, swelling, pus)
      Condition worsens despite treatment
      If you have diabetes or circulation issues
''';
    } else if (symptomsInput.contains('eye pain')) {
      response = '''
    Symptoms:
      Sore, tired, or burning eyes
      Blurred or double vision
      Dry or watery eyes
      Headaches or difficulty concentrating
      Neck, shoulder, or back pain from poor posture
    Medications:
      Artificial Tears:Systane, Refresh
      Prescription Drops:cyclosporine, Restasis
      Pain Relief: Paracetamol or ibuprofen for associated headaches
    Natural Remedies:
      Follow the 20-20-20 Rule: Every 20 minutes, look at something 20 feet away for 20 seconds
      Apply a warm compress to relax eye muscles
      Blink frequently to reduce dryness
      Adjust lighting to avoid glare
    Prevention Tips:
      Use anti-glare screens and adjust screen brightness
      Maintain proper screen distance (about 20–28 inches)
      Ensure proper posture and ergonomics at your workstation
      Get regular eye checkups and use prescribed glasses if needed
    When to See a Doctor:
      Persistent eye strain despite lifestyle adjustments
      Severe pain, redness, or vision changes
      Frequent headaches linked to eye use
      If using screens or reading causes significant discomfort
''';
    } else if (symptomsInput.contains('insect bite')) {
      response = '''
    Symptoms:
      Red, swollen, or itchy bump at the bite site
      Pain or burning sensation
      In some cases, blisters or hives
      Severe allergic reactions: difficulty breathing, swelling, dizziness (anaphylaxis)
    Medications:
      OTC Antihistamines: Loratadine
      Topical Creams: Hydrocortisone cream, calamine lotion
      Pain Relief: Paracetamol or ibuprofen for pain/swelling
      Epinephrine Injector: For severe allergic reactions (e.g., EpiPen)
    Natural Remedies:
      Apply a cold compress to reduce swelling
      Use aloe vera gel for soothing
      Dab a paste of baking soda and water on the bite
      Use tea tree oil or diluted apple cider vinegar for itching
    Prevention Tips:
      Use insect repellents (DEET or natural alternatives like citronella)
      Wear protective clothing in insect-prone areas
      Avoid stagnant water to reduce mosquito breeding
      Install screens and use mosquito nets indoors
    When to See a Doctor:
      Symptoms of an allergic reaction (e.g., swelling of lips, difficulty breathing)
      Signs of infection (redness, warmth, pus, fever)
      Persistent or worsening symptoms after treatment
      Multiple bites causing significant swelling or discomfort
''';
    } else if (symptomsInput.contains('eye irritation')) {
      response = '''
    Symptoms:
      Redness or bloodshot eyes
      Itching or burning sensation
      Watery or excessive tearing
      Sensitivity to light
      Swelling around the eyes or eyelids
    Medications:
      Antihistamine Eye Drops: For allergy-related irritation (e.g., ketotifen, azelastine)
      Artificial Tears: Lubricating drops to relieve dryness and irritation (e.g., Systane, Refresh)
      Prescription Drops: Corticosteroids or anti-inflammatory drops for severe cases
    Natural Remedies:
      Rinse eye gently with clean, lukewarm water
      Apply a cold compress to reduce swelling and discomfort
      Use aloe veragel or chamomile tea bags as compresses to soothe irritation
      Avoid rubbing your eyes, as it can worsen irritation
    Prevention Tips:
      Maintain proper hygiene by washing hands before touching your eyes
      Avoid allergens (dust, pollen, pet dander) and irritants (smoke, strong odors)
      Use protective eyewear when in dusty or windy environments
      Take regular breaks from screens to reduce eye strain
    When to See a Doctor:
      Persistent irritation or discomfort despite treatment
      Vision changes or severe redness
      Signs of infection (pus, severe swelling, or pain)
      If irritation occurs after exposure to chemicals or foreign objects
''';
    } else if (symptomsInput.contains('dry eyes')) {
      response = '''
    Symptoms:
      Stinging or burning sensation in the eyes
      Redness or irritation
      Blurred vision or fluctuations in vision
      Sensitivity to light
      A feeling of having something in the eye
    Medications:
      Artificial Tears: Lubricating eye drops (e.g., Systane, Refresh, Genteal)
      Prescription Drops: Cyclosporine (Restasis) or lifitegrast (Xiidra) for chronic dry eye
      Oral Medications: Omega-3 fatty acid supplements for some patients
    Natural Remedies:
      Apply warm compresses to the eyes to stimulate tear production
      Use a humidifier to maintain moisture in the air
      Stay hydrated by drinking plenty of water
      Blink frequently, especially during screen use
    Prevention Tips:
      Take regular breaks from screens (follow the 20-20-20 rule)
      Wear sunglasses outdoors to protect from wind and sun
      Avoid direct airflow from fans or air conditioning
      Maintain a healthy diet rich in omega-3 fatty acids (e.g., fish, flaxseeds)
    When to See a Doctor:
      Persistent dry eyes despite home treatment.
      Severe discomfort or pain in the eyes
      Vision changes or difficulty with daily activities
      If symptoms interfere significantly with quality of life
''';
    } else if (symptomsInput.contains('blur vision')) {
      response = '''
    Symptoms:
      Sudden, temporary loss of clarity in vision
      Blurred or hazy vision that may last seconds to minutes
      Occasional dizziness or lightheadedness accompanying vision changes
      Visual disturbances like spots or flashes of light
    Common Causes:
      Eye strain from prolonged screen time or reading
      Migraines or tension headaches
      Changes in blood sugar levels (especially in diabetics)
      Dry eyes or lack of lubrication
      Rapid changes in position (e.g., standing up quickly)
      Fatigue or lack of sleep
    Medications:
      Eye Drops: Artificial tears for dry eyes
      Pain Relief: Over-the-counter pain relievers for associated headaches
      Prescription Medications: For underlying conditions (e.g., migraine treatment)
    Natural Remedies:
      Follow the 20-20-20 Rule: Every 20 minutes, look at something 20 feet away for 20 seconds
      Stay hydrated to maintain optimal eye function
      Use a warm compress on closed eyes to relieve strain
      Ensure adequate lighting while reading or using screens
    Prevention Tips:
      Maintain a regular sleep schedule to reduce fatigue
      Adjust screen brightness and take regular breaks
      Keep regular eye check-ups to monitor vision changes
      Manage underlying health conditions, such as diabetes or hypertension
    When to See a Doctor:
      Frequent or recurring episodes of blurred vision
      Associated with headaches, dizziness, or other neurological symptoms
      Sudden onset, especially after an injury or trauma to the eye
      If it affects daily activities or quality of life
''';
    } else if (symptomsInput.contains('stress')) {
      response = '''
    Symptoms
      Anxiety, irritability, or restlessness
      Fatigue, headaches, or rapid heartbeat
      Sleep disturbances or difficulty focusing
    Medications
      Anti-Anxiety (e.g., Alprazolam): Short-term use for severe stress
      Antidepressants (e.g., Sertraline): For chronic stress or depression
      Herbal Remedies (e.g., Ashwagandha): Natural stress relievers
    Natural Remedies
      Deep breathing and meditation
      Exercise (e.g., yoga, walking)
      Journaling and aromatherapy (lavender, chamomile)
    Diet Tips:
      Eat whole grains, nuts, and dark chocolate
      Avoid caffeine, alcohol, and sugary foods
      Stay hydrated
    Preventions:
      Practice time management
      Take regular breaks and rest
      Set boundaries and connect with loved ones
    When to See a Doctor
      Stress affects daily life or relationships
      Persistent physical symptoms (e.g., chest pain)
      Feelings of hopelessness or anxiety worsen
''';
    } else if (symptomsInput.contains('depression')) {
      response = '''
    Symptoms
      Persistent sadness or hopelessness
      Loss of interest in activities once enjoyed
      Fatigue, low energy, or difficulty concentrating
      Changes in appetite or weight (increase or decrease)
      Trouble sleeping or excessive sleep
      Thoughts of self-harm or suicide (seek immediate help)
    Medications
      Antidepressants (SSRIs):E.g., Sertraline, Escitalopram, Fluoxetine
      Atypical Antidepressants:E.g., Bupropion (for low energy and focus)
      Tricyclic Antidepressants (TCAs):E.g., Amitriptyline (used for severe cases)
      Note: Medications should only be taken under a doctor’s supervision
    Natural Remedies
      Regular Exercise:At least 30 minutes of physical activity boosts mood by releasing endorphins
      Sunlight Exposure:Spend time outdoors to improve serotonin levels
      Mindfulness and Meditation:Helps reduce negative thoughts and improve focus
      Journaling:Write down thoughts to release emotions and clarify feelings
    Dietary Tips:
      Eat omega-3-rich foods (e.g., fish, flaxseeds) to support brain health
      Include fruits, vegetables, and whole grains for steady energy
      Avoid alcohol, caffeine, and junk food
      Stay hydrated to improve mental clarity
    Prevention Tips
      Build a support system—stay connected with friends and family
      Maintain a consistent sleep schedule
      Break big tasks into smaller, manageable steps
      Seek professional help early if symptoms appear
    When to See a Doctor
      Depression lasts more than 2 weeks
      Difficulty functioning in daily life
      Suicidal thoughts or feelings of self-harm (seek urgent help)
''';
    } else if (symptomsInput.contains('anxiety')) {
      response = '''
    Symptoms
      Excessive worry or fear.
      Restlessness or feeling "on edge."
      Rapid heartbeat, sweating, or trembling
      Difficulty concentrating or sleeping
      Shortness of breath or chest tightness
    Medications
      Anti-Anxiety (Benzodiazepines):E.g., Alprazolam, Lorazepam (short-term use only)
      SSRIs (Antidepressants):E.g., Sertraline, Escitalopram (for long-term management)
      Beta-Blockers:E.g., Propranolol (reduces physical symptoms like rapid heartbeat)
      Herbal Remedies:E.g., Ashwagandha, Passionflower (natural calming agents)
    Natural Remedies
      Deep Breathing:Practice slow, deep breaths (e.g., inhale for 4 seconds, hold for 7, exhale for 8)
      Meditation and Yoga:Helps calm the mind and body
      Physical Exercise:30 minutes of activity daily to release stress-reducing endorphins
      Chamomile Tea:Soothes nerves and reduces anxiety
    Dietary Tips
      Eat magnesium-rich foods (e.g., leafy greens, almonds)
      Include omega-3s (e.g., fish, walnuts) for brain health
      Avoid caffeine, alcohol, and sugary foods
      Stay hydrated to reduce physical stress symptoms
    Prevention Tips
      Establish a regular routine with balanced work and relaxation
      Avoid overloading your schedule
      Practice grounding techniques (e.g., 5-4-3-2-1 sensory exercise)
      Build a support system of trusted friends or family
    When to See a Doctor
      Anxiety persists for more than 6 months
      Difficulty functioning in daily activities
      Symptoms include panic attacks or physical issues (e.g., chest pain)
      Suicidal thoughts or extreme distress (seek urgent help)
''';
    } else if (symptomsInput.contains('acne')) {
      response = '''
    Symptoms
      Pimples, blackheads, or cysts
      Oily skin and clogged pores
      Redness and inflammation
    Medications
      Benzoyl Peroxide (e.g., PanOxyl, Oxy): Kills acne-causing bacteria
      Salicylic Acid (e.g., Clean & Clear, Neutrogena Oil-Free Acne Wash): Unclogs pores
      Topical Retinoids (e.g., Adapalene, Retin-A): Prevents clogged pores and promotes skin renewal
      Antibiotics (e.g., Clindamycin, Erythromycin): Reduces inflammation and bacteria
      Isotretinoin (e.g., Accutane): For severe acne, reduces oil production
      Azelaic Acid (e.g., Finacea): Reduces inflammation and bacteria, good for sensitive skin
      Sulfur (e.g., Mario Badescu Drying Lotion): Helps absorb excess oil and reduce acne
      Tea Tree Oil Products (e.g., The Body Shop Tea Tree Oil): Natural antibacterial for acne spots
      Niacinamide (e.g., The Ordinary Niacinamide 10% + Zinc 1%): Reduces redness and regulates oil production
    Natural Remedies
      Tea Tree Oil: Reduces bacteria and inflammation
      Aloe Vera: Soothes and heals acne
      Honey: Antibacterial and soothing
    Diet Tips
      Avoid sugary foods
      Include omega-3s (e.g., fish, flaxseeds)
      Stay hydrated
    Prevention Tips
      Cleanse twice a day
      Avoid touching your face
      Use non-comedogenic products
    When to See a Doctor
      Acne doesn’t improve
      Cystic acne or scarring occurs
''';
    } else if (symptomsInput.contains('dry skin')) {
      response = '''
    Symptoms
      Tightness or roughness in the skin
      Flaky or peeling skin
      Itchy or irritated skin
      Redness or cracking, especially on hands, feet, or elbows
    Medications & Treatments
      CeraVe Moisturizing Cream:Contains ceramides, hyaluronic acid, and glycerin to restore the skin’s moisture barrier
      Eucerin Advanced Repair Cream:Rich in ceramides and natural moisturizing factors, ideal for very dry skin
      Vaseline (Petrolatum):A thick ointment that locks in moisture, providing long-lasting hydration for extremely dry patches
      Neutrogena Hydro Boost Water Gel:Lightweight gel with hyaluronic acid, great for intense hydration without a greasy feel
      Aquaphor Healing Ointment:A petroleum-based ointment that helps heal dry, cracked skin, especially on hands and feet
      Cetaphil Daily Hydrating Lotion:Lightweight, non-greasy formula that provides 24-hour hydration with hyaluronic acid
      AmLactin (Alpha Hydroxy Acid Lotion):Contains lactic acid to exfoliate dead skin cells and hydrate at the same time
      Aveeno Skin Relief Moisturizing Lotion:Contains soothing ingredients like oat extract to relieve dry, irritated skin
      Vanicream Moisturizing Cream:Ideal for sensitive skin, free from dyes, fragrances, and parabens, helping to restore skin hydration
      The Body Shop Shea Body Butter:Rich in shea butter, this deeply nourishing moisturizer provides intense hydration
      Kiehl's Creme de Corps:A rich, non-greasy body moisturizer that hydrates and softens very dry skin
      Epidermal Repair (e.g., EltaMD):Contains ingredients to repair and protect the skin barrier, great for dry and irritated skin
    Natural Remedies
      Coconut Oil:A natural moisturizer with anti-inflammatory properties
      Aloe Vera:Soothes dry, irritated skin and helps retain moisture
      Olive Oil:Rich in antioxidants, it hydrates and softens the skin
      Honey:Acts as a natural humectant, drawing moisture into the skin
    Dietary Tips
      Omega-3 Fatty Acids (e.g., Salmon, Chia Seeds):Promote skin hydration from within
      Stay Hydrated:Drink plenty of water throughout the day
      Avoid Dehydrating Foods:Limit caffeine and alcohol as they can cause dehydration
    Prevention Tips
      Avoid Hot Showers:Hot water can strip the skin’s natural oils. Use lukewarm water instead
      Moisturize Immediately After Bathing:Apply moisturizer while the skin is still damp to lock in moisture
      Use Gentle Cleansers:Choose hydrating, fragrance-free soaps or body washes
      Wear Gloves in Cold Weather:Protect hands from harsh, dry air
    When to See a Doctor
      Dry skin doesn’t improve with moisturizing
      Severe cracking or bleeding of the skin
      Skin becomes inflamed or infected
''';
    } else if (symptomsInput.contains('oily skin')) {
      response = '''
    Symptoms
      Shiny, greasy appearance, especially in the T-zone (forehead, nose, chin)
      Enlarged pores
      Frequent acne breakouts or blackheads
      Skin feels heavy or clogged
    Medications & Treatments
      Salicylic Acid (e.g., Neutrogena Oil-Free Acne Wash):Helps exfoliate skin and unclog pores, preventing acne and controlling oil
      Benzoyl Peroxide (e.g., PanOxyl, Clean & Clear Continuous Control):Kills acne-causing bacteria and controls oil production
      Tea Tree Oil (e.g., The Body Shop Tea Tree Oil):Natural antibacterial that reduces oil and prevents breakouts
      Niacinamide (e.g., The Ordinary Niacinamide 10% + Zinc 1%):Reduces oil production and minimizes pores while calming inflammation
      Clay Masks (e.g., Aztec Secret Indian Healing Clay):Absorbs excess oil, reduces acne, and tightens pores
      Oil-Free Moisturizers (e.g., CeraVe PM Facial Moisturizing Lotion):Hydrates skin without clogging pores or adding oil
      Mattifying Products (e.g., Smashbox Photo Finish Mattifying Primer):Controls shine and provides a matte finish throughout the day
      Retinoids (e.g., Retin-A, Differin):Promotes cell turnover, reduces clogged pores, and controls oil production
      Alpha Hydroxy Acids (AHAs) (e.g., Glycolic Acid):
      Gently exfoliates skin and balances oil production, ideal for oily and acne-prone skin
    Natural Remedies
      Aloe Vera:Soothes skin and regulates oil production
      Apple Cider Vinegar (diluted):Helps balance the skin’s pH and reduce oil
      Lemon Juice:Natural astringent that controls oil and brightens skin
      Witch Hazel:Tightens pores and reduces excess oil without drying out the skin
    Dietary Tips
      Avoid Greasy Foods:Limit oily, fried, or processed foods that may trigger oil production
      Drink Plenty of Water:Helps flush out toxins and maintain balanced skin
      Include Omega-3 Fatty Acids:Foods like salmon, chia seeds, and walnuts can help reduce inflammation and balance oil production
    Prevention Tips
      Cleanse Twice a Day:
        Use a gentle cleanser to remove excess oil without stripping the skin
        Use Oil-Free or Non-Comedogenic Products:
        Ensure makeup, sunscreen, and moisturizers are oil-free and don’t clog pores
      Exfoliate Regularly:
        Gently exfoliate to remove dead skin cells and prevent clogged pores
        Avoid Touching Your Face:
        Minimize transferring oil and bacteria from hands to face
    When to See a Doctor
      Acne or oily skin persists despite treatment
      Severe acne, scarring, or cystic acne develops
      Skin irritation or other skin conditions appear
''';
    } else if (symptomsInput.contains('combination skin')) {
      response = '''
    Symptoms
      Oily T-zone (forehead, nose, chin) with dry or normal cheeks
      Enlarged pores in the T-zone
      Flaky or rough skin on the cheeks
      Occasional breakouts in the T-zone and dryness on the sides of the face
    Medications & Treatments
      Gentle Cleansers (e.g., CeraVe Hydrating Cleanser, Neutrogena Fresh Foaming Cleanser):Cleanse without stripping skin, maintaining balance between oily and dry areas
      Niacinamide (e.g., The Ordinary Niacinamide 10% + Zinc 1%):Controls oil in the T-zone and soothes dry areas
      Salicylic Acid (e.g., Neutrogena Oil-Free Acne Wash): Helps to control oil in the T-zone and prevent breakouts, while being gentle on dry areas
      Moisturizers (e.g., CeraVe AM Facial Moisturizing Lotion, Clinique Moisture Surge):Lightweight and hydrating, perfect for balancing combination skin
      Clay Masks (e.g., Aztec Secret Indian Healing Clay):Absorbs excess oil in the T-zone while soothing dry areas on the cheeks
      Hydrating Toners (e.g., Klairs Supple Preparation Unscented Toner):Rebalances moisture levels, ideal for combination skin
      Retinoids (e.g., Differin):For overall skin texture improvement and reducing breakouts, while being gentle on dry areas
    Natural Remedies
      Aloe Vera:Hydrates and balances the skin without making it greasy
      Honey:Moisturizes dry areas while also acting as an antibacterial for oily spots
      Green Tea Extract:Reduces excess oil and provides antioxidant protection for combination skin
      Oatmeal Mask:Soothes dry, irritated areas and absorbs oil in the T-zone
    Dietary Tips
      Avoid Excess Sugar:Limit sugary and processed foods that can cause oil production and imbalance
      Stay Hydrated:Drink plenty of water to maintain skin balance and hydration
      Incorporate Omega-3s:Foods like fish, flaxseeds, and walnuts can help reduce inflammation and balance skin
    Prevention Tips
      Use a Gentle Exfoliator:Exfoliate 1–2 times a week to prevent clogged pores in the T-zone and remove dry skin on cheeks
      Avoid Over-Moisturizing:Use a light moisturizer for dry areas to prevent excess oil production
      Double Cleanse:Cleanse the oily areas with a gel cleanser and use a milder cleanser for the cheeks
    When to See a Doctor
      If skin imbalance persists despite treatment
      Severe acne, redness, or irritation develops
      If you have concerns about the health of your skin or any other symptoms
''';
    } else if (symptomsInput.contains('hyperpigmentation')) {
      response = '''
    Symptoms
      Dark spots or patches on the skin, often on the face, neck, or hands
      Uneven skin tone or skin discoloration
      Patches that appear darker than the surrounding skin, usually due to sun exposure, acne scars, or hormonal changes
    Medications & Treatments
      Vitamin C (e.g., SkinCeuticals C E Ferulic, La Roche-Posay Pure Vitamin C Face Serum):Brightens dark spots and reduces melanin production
      Hydroquinone (e.g., Ambi Fade Cream, Meladerm):Bleaching agent that lightens dark spots over time
      Retinoids (e.g., Retin-A, Differin):Accelerates skin cell turnover and reduces the appearance of hyperpigmentation
      Niacinamide (e.g., The Ordinary Niacinamide 10% + Zinc 1%):Reduces dark spots, regulates melanin production, and evens skin tone
      Alpha Hydroxy Acids (AHAs) (e.g., Glycolic Acid, Pixi Glow Tonic):Exfoliates the skin, speeding up the shedding of hyperpigmented skin cells
      Azelaic Acid (e.g., The Ordinary Azelaic Acid Suspension 10%):Reduces pigmentation and brightens the skin, while being gentle
      Chemical Peels (e.g., Glycolic or Lactic Acid Peels):Performed by dermatologists to reduce pigmentation and promote healthy skin renewal
      Sunscreen (e.g., La Roche-Posay Anthelios Melt-in Milk Sunscreen SPF 60):Daily application is essential to prevent worsening of hyperpigmentation from sun exposure
    Natural Remedies
      Aloe Vera:Reduces pigmentation and helps soothe irritated skin
      Lemon Juice:Natural bleaching agent, but use cautiously as it can irritate the skin
      Green Tea Extract:Helps to reduce melanin production and lighten dark spots
      Turmeric:Contains curcumin, which can lighten pigmentation and reduce inflammation
    Dietary Tips
      Eat Vitamin C-Rich Foods:Citrus fruits, strawberries, and bell peppers help brighten skin from within
      Incorporate Antioxidants:Foods like berries, leafy greens, and nuts help fight oxidative stress and prevent skin damage
      Stay Hydrated:Drink plenty of water to maintain healthy, glowing skin
    Prevention Tips
      Use Sunscreen Daily:Always apply SPF 30 or higher, even on cloudy days, to prevent further darkening of spots
      Avoid Picking Pimples:Picking or popping blemishes can worsen post-inflammatory hyperpigmentation (PIH)
      Gentle Exfoliation:Regular, gentle exfoliation helps to fade hyperpigmentation faster by removing dead skin cells
    When to See a Doctor
      If hyperpigmentation persists despite treatment
      If the pigmentation worsens or becomes painful
      If you have concerns about a mole or pigmentation that looks unusual or suspicious
''';
    } else if (symptomsInput.contains('dark circles')) {
      response = '''
    Symptoms
      Dark or discolored skin under the eyes, often making the area appear hollow or puffy
      Can be accompanied by swelling or puffiness
      More noticeable in the morning or when tired
    Causes
      Lack of Sleep: Poor rest leads to blood vessel dilation, causing dark circles
      Genetics: Hereditary factors can contribute to thinner skin around the eyes
      Aging: Thinning skin and loss of collagen as you age can make dark circles more prominent
      Allergies: Allergic reactions can cause dark circles due to inflammation or rubbing eyes
      Dehydration: Lack of water can make the skin under the eyes look dull and sunken
    Medications & Treatments
      Caffeine (e.g., The Ordinary Caffeine Solution 5% + EGCG):Reduces puffiness and constricts blood vessels to lighten dark circles
      Retinoids (e.g., Retin-A, Differin):Boosts collagen production and helps thicken skin under the eyes, reducing the appearance of dark circles
      Vitamin C (e.g., La Roche-Posay Pure Vitamin C Face Serum):Brightens the under-eye area and improves skin texture
      Hyaluronic Acid (e.g., Neutrogena Hydro Boost Eye Gel-Cream):Hydrates and plumps the skin, reducing the look of dark circles
      Peptides (e.g., Olay Eyes Brightening Cream):Strengthens and firms the delicate skin under the eyes
      Hydrocortisone Cream (1%):Helps reduce inflammation and darkening caused by allergies or irritation (use cautiously)
    Natural Remedies
      Cucumber Slices:Cool cucumber slices can soothe, hydrate, and reduce puffiness
      Tea Bags (Green or Chamomile):The caffeine and antioxidants help reduce swelling and dark circles
      Almond Oil:Gently massaging almond oil into the under-eye area can help lighten dark circles over time
      Cold Compress:Use chilled spoons or a cold compress to reduce swelling and constrict blood vessels
    Dietary Tips
      Stay Hydrated:Drink plenty of water to prevent dehydration, which can make dark circles worse
      Eat Vitamin K-Rich Foods:Leafy greens, broccoli, and green beans help strengthen blood vessels
      Incorporate Iron:Iron-rich foods (e.g., spinach, legumes) help combat anemia, a common cause of dark circles
    Prevention Tips
      Get Enough Sleep:Aim for 7-9 hours of sleep each night to prevent dark circles caused by fatigue
      Use Sunscreen:Protect the delicate skin under your eyes with sunscreen to prevent further pigmentation
      Avoid Rubbing Your Eyes:Rubbing can irritate and worsen dark circles
      Elevate Your Head While Sleeping:Use an extra pillow to reduce fluid retention around the eyes
    When to See a Doctor
      Dark circles persist despite lifestyle changes or treatments
      Accompanied by other unusual symptoms like puffiness, pain, or vision changes
      If dark circles are causing significant distress or affecting self-esteem
''';
    } else if (symptomsInput.contains('wrinkles')) {
      response = '''
    Symptoms
      Fine lines or deep creases on the skin, typically around the eyes, mouth, and forehead
      kin sagging or loss of firmness
      Thinning skin or rough texture
    Causes
      Aging: Collagen and elastin production decrease with age, leading to wrinkles
      Sun Exposure: UV radiation damages skin fibers and accelerates the aging process
      Facial Expressions: Repeated movements (smiling, frowning) cause expression lines
      Smoking: Reduces blood flow to the skin, contributing to wrinkles and dryness
      Genetics: Hereditary factors determine how your skin ages
      Dehydration: Lack of moisture can cause skin to look dry and wrinkled
    Medications & Treatments
      Retinoids (e.g., Retin-A, Differin):Stimulate collagen production and improve skin texture
      Hyaluronic Acid (e.g., Neutrogena Hydro Boost):Hydrates and plumps the skin, reducing the appearance of fine lines
      Vitamin C (e.g., SkinCeuticals C E Ferulic):Brightens and firms the skin while protecting against UV damage
      Peptides (e.g., Olay Regenerist):Boost collagen and skin elasticity
      Alpha Hydroxy Acids (AHAs) (e.g., Glycolic Acid):Exfoliate and smooth the skin, reducing the appearance of fine lines
      Botox/Injections (e.g., Botox, Dysport):Temporarily relaxes muscles to smooth out deep lines and wrinkles
      Chemical Peels:Performed by dermatologists to exfoliate and reveal fresher, smoother skin
    Natural Remedies
      Aloe Vera:Promotes skin healing and reduces fine lines
      Coconut Oil:Moisturizes and helps plump up the skin
      Green Tea:Rich in antioxidants, it helps reduce the appearance of wrinkles
      Olive Oil:Moisturizes and improves skin elasticity
      Honey:A natural humectant, helps hydrate and rejuvenate skin
    Dietary Tips
      Eat Antioxidant-Rich Foods:
      Berries, nuts, and leafy greens protect the skin from damage
      Include Omega-3 Fatty Acids:Foods like salmon, flaxseeds, and chia seeds improve skin elasticity
      *Stay Hydrated:Drink plenty of water to maintain skin moisture and prevent dryness
    Prevention Tips
      Apply Sunscreen Daily:Use SPF 30 or higher every day to protect against UV damage
      Moisturize Regularly:Use a rich moisturizer to keep skin hydrated and plump
      Quit Smoking:Smoking accelerates the aging process and worsens Wrinkles
      Get Enough Sleep:Aim for 7-9 hours of sleep to allow skin repair
      Gentle Skin Care:Avoid harsh scrubbing or pulling of the skin; opt for gentle cleansers and pat skin dry
    When to See a Doctor
      Wrinkles worsen despite using topical treatments
      You're considering injectable treatments like Botox
      You notice unusual skin changes or deep lines
''';
    } else if (symptomsInput.contains('sun burn')) {
      response = '''
    Symptoms
      Red, inflamed skin after sun exposure
     Pain or tenderness in the affected area
      Peeling or blistering skin (severe cases)
      Swelling, heat, or itching in the sunburned area
      Fever and chills (in extreme cases)
    Causes
      Excessive Sun Exposure:Skin damage from ultraviolet (UV) radiation
      Lack of Sunscreen:Not using sunscreen or reapplying it regularly
      Fair Skin:Lighter skin is more prone to sunburn
      Prolonged Exposure to UV Radiation:Staying in the sun for long periods without protection
    Medications & Treatments
      Aloe Vera Gel:Soothes and cools sunburned skin, providing relief from redness and inflammation
      Hydrocortisone Cream (1%):Reduces inflammation and itching caused by sunburn
      Ibuprofen or Paracetamol:Pain relievers to reduce discomfort and inflammation
      Antihistamines (e.g., Diphenhydramine):Can help relieve itching and swelling caused by sunburn
      Moisturizers with Glycerin or Hyaluronic Acid:Help hydrate and replenish the skin's moisture after sun exposure
      Cold Compress:Apply to sunburned areas to reduce pain and heat
    Natural Remedies
      Cucumber Slices:Cool and soothe the skin with anti-inflammatory properties
      Oatmeal Bath:Add colloidal oatmeal to a lukewarm bath to reduce irritation and inflammation
      Coconut Oil:Helps hydrate the skin and reduce peeling (use after the initial heat subsides)
      Honey:A natural humectant that helps lock in moisture and promote healing
    Dietary Tips
      Increase Water Intake:Hydrate to help your skin recover and prevent dehydration
      Eat Vitamin C-Rich Foods:Citrus fruits, berries, and leafy greens to support skin healing
      Include Omega-3 Fatty Acids:Foods like fish, walnuts, and flaxseeds can reduce inflammation
    Prevention Tips
      Use Sunscreen:Apply SPF 30 or higher every 2 hours, and more often if swimming or sweating
      Seek Shade:Avoid direct sunlight, especially between 10 a.m. and 4 p.m
      Wear Protective Clothing:Use hats, sunglasses, and clothing with SPF protection
      Avoid Tanning Beds:Do not use tanning beds, as they can cause similar skin damage
    When to See a Doctor
      If sunburn is severe (e.g., blistering, fever)
      If you have sunburns that don't heal within a few days
      If you experience symptoms like nausea or dizziness
''';
    } else if (symptomsInput.contains('skin allergy')) {
      response = '''
    Symptoms
      Itchy, Red, or Swollen Skin
      Rashes or hives (raised, red bumps)
      Blisters or welts
      Dry, Cracked Skin or peeling
      Burning Sensation or discomfort
      Flaking or scaling of the skin (in some cases)
    Common Triggers
      Allergens in Cosmetics:Fragrances, preservatives, or dyes in skincare or makeup products
      Environmental Allergens:Pollen, dust, pet dander, or mold
      Food Allergies:Dairy, nuts, shellfish, etc., causing skin reactions
      Insect Bites/Stings:Bites from mosquitoes, bees, or other insects
      Nickel or Metal Sensitivity:Jewelry, belts, or other metal items causing skin irritation
      Chemical Irritants:Detergents, soaps, or cleaning products
      Medications & TreatmentsAntihistamines (e.g., Diphenhydramine, Cetirizine):Relieves itching, swelling, and redness caused by skin allergies
      Hydrocortisone Cream (1%):Reduces inflammation and irritation in allergic rashes
      Calamine Lotion:Soothes itchy, irritated skin and helps dry out rashes
      Oral Steroids (e.g., Prednisone):For severe allergic reactions (prescribed by a doctor)
      Topical Antihistamines (e.g., Benadryl Cream):Applied directly to the affected area for quick relief
      Cold Compress:Helps reduce swelling, redness, and itching
    Natural Remedies
      Aloe Vera Gel:Soothes irritated skin and promotes healing
      Oatmeal Baths:Helps reduce itching and inflammation from allergies
      Coconut Oil:Moisturizes and has anti-inflammatory properties
      Baking Soda Paste:Apply to the affected area to calm irritation and itching
      Chamomile Tea Compress:Cool chamomile tea compresses help reduce redness and swelling
    Dietary Tips
      Avoid Known Allergens:Stay away from foods or substances known to trigger allergic reactions
      Eat Anti-Inflammatory Foods:Omega-3-rich foods (like salmon, flaxseeds) to reduce skin inflammation
      Stay Hydrated:Drink plenty of water to help keep your skin hydrated
    Prevention Tips
      Patch Test New Products:Always test skincare products on a small area before full application
      Use Gentle, Fragrance-Free Products:Opt for hypoallergenic or dermatologist-tested skincare items
      Wear Protective Clothing:When exposed to allergens like pollen, use hats and gloves
      Avoid Scratching:Scratching can worsen irritation and lead to infections
    When to See a Doctor
      Severe Reactions:Difficulty breathing, swelling of lips or tongue, dizziness (anaphylaxis)
      Persistent or Worsening Symptoms:If symptoms don't improve or get worse with OTC treatments
      Skin Infections:If the allergic reaction leads to open wounds, pus, or fever
''';
    } else if (symptomsInput.contains('dandruff')) {
      response = '''
    Symptoms
      White or Yellow Flakes: Small, dry flakes of dead skin visible on the scalp or shoulders
      itchy Scalp: Persistent itching on the scalp
      Dry Scalp: A feeling of dryness or tightness on the scalp
      Greasy Scalp: Oily scalp with flaking, sometimes leading to an oily appearance
    Causes
      Seborrheic Dermatitis: An inflammatory skin condition leading to flaky, oily skin on the scalp
      Malassezia Fungus: An overgrowth of a yeast-like fungus on the scalp can trigger dandruff
      Dry Skin: Cold, dry weather can lead to a dry, flaky scalp
      Skin Sensitivity or Allergies: Sensitivity to hair care products or allergens
      Not Shampooing Enough: Infrequent washing can cause a buildup of oils and dead skin cells
      Stress: Can worsen or trigger dandruff
    Medications & Treatments
      Anti-Dandruff Shampoos:Selenium Sulfide (e.g., Selsun Blue): Helps reduce fungus growth and controls oil
      Zinc Pyrithione (e.g., Head & Shoulders): Antifungal and antibacterial to fight dandruff
      Ketoconazole (e.g., Nizoral): Strong antifungal that targets dandruff-causing fungi
      Coal Tar Shampoos (e.g., Neutrogena T/Gel): Slows down the production of skin cells on the scalp
      Salicylic Acid (e.g., Neutrogena T/Sal): Exfoliates and removes excess scalp skin
      Tea Tree Oil:Natural antifungal and antimicrobial properties that can reduce dandruff
      Use diluted to avoid irritation
      Hydrocortisone Cream (1%):For inflammation and itching caused by seborrheic dermatitis
      Coconut Oil:Natural moisturizer that can reduce dryness and improve scalp health
    Natural Remedies
      Apple Cider Vinegar:Helps balance scalp pH and reduce fungal growth, reducing dandruff
      Aloe Vera Gel:Soothes irritation and provides moisture to dry, itchy skin
      Lemon Juice:Natural astringent that can reduce oil buildup and balance scalp pH
      Baking Soda:Gently exfoliates the scalp and removes excess oil, but use sparingly to avoid irritation
    Dietary Tips
      Include Omega-3 Fatty Acids:Foods like salmon, flaxseeds, and walnuts promote scalp health and reduce dryness
      Stay Hydrated:Drink plenty of water to keep skin and scalp hydrated
      Avoid Sugary or Processed Foods:Can trigger or worsen dandruff, particularly in those with yeast-related causes
    Prevention Tips
      Shampoo Regularly:Cleanse your scalp at least twice a week to remove excess oil and dead skin cells
      Avoid Harsh Hair Products:Choose gentle, sulfate-free products to avoid irritating the scalp
      Reduce Stress:Stress management can help reduce flare-ups of dandruff
      Limit Hair Styling Products:Products like gel or hairspray can buildup on the scalp, worsening dandruff
    When to See a Doctor
      Dandruff doesn't improve with over-the-counter treatments
      Severe itching, inflammation, or hair loss occurs
      Scalp redness or sores appear, which could indicate an infection
''';
    } else if (symptomsInput.contains('hair loss')) {
      response = '''
    Symptoms:
      Gradual thinning on the scalp (common in aging)
      Patches of bald spots or circular areas of hair loss
      Sudden loosening of hair, leading to clumps falling out
      Full-body hair loss in cases like chemotherapy or medical conditions
      Scaling or patches on the scalp (indicates infections)
    Medications:
      Minoxidil (Rogaine):topical treatment for hair regrowth
      Finasteride (Propecia): Prescription oral medication for male pattern baldness
      Corticosteroids: Injections or creams for conditions like alopecia areata
      Antifungal Treatments: For hair loss caused by scalp infections (e.g., ketoconazole shampoo)
    Natural Remedies:
      Massage the scalp with oils like coconut, castor, or rosemary oil to improve circulation
      Use aloe vera to soothe the scalp and reduce dandruff
      Consume foods rich in biotin, zinc, iron, and protein (e.g., eggs, nuts, leafy greens)
      Onion juice application, known to promote hair growth (limited evidence)
    Prevention Tips:
      Avoid harsh hair treatments (excessive coloring, bleaching, or heat styling)
      Use mild, sulfate-free shampoos and conditioners
      Protect hair from excessive sun exposure
      Manage stress through relaxation techniques like yoga or meditation
    When to See a Doctor:
      Sudden or excessive hair loss
      Hair loss with symptoms like itching, redness, or scaling
      Bald patches or thinning associated with hormonal changes
''';
    } else if (symptomsInput.contains('split ends')) {
      response = '''
    Symptoms:
      Hair strands split at the tips
      Dry, frayed, or uneven hair ends
      Brittle texture and difficulty styling hair
    Causes:
      Excessive heat styling (e.g., blow-drying, straightening)
      Chemical treatments like coloring or perming
      Overwashing or using harsh shampoos
      Environmental factors (sun exposure, pollution)
    Treatments:
      Haircuts: Regular trims (every 6–8 weeks) to remove split ends
      Leave-In Conditioners: Use products with keratin or argan oil for repair
      Hair Masks: Deep conditioning with coconut oil, shea butter, or protein-based masks
    Natural Remedies:
      Apply a blend of olive oil and honey to nourish dry ends
      Use avocado or egg masks to strengthen hair
      Rinse with diluted apple cider vinegar for shine and moisture retention
      Massage with warm coconut or almond oil before washing
    Prevention Tips
      Avoid excessive heat styling; use heat protectant sprays if necessary
      Gently pat hair dry with a towel instead of rubbing
      Use a wide-tooth comb to prevent breakage
      Choose sulfate-free shampoos and conditioners
      Protect hair from harsh weather (e.g., wear a hat in the sun)
    When to See a Stylist:
      If split ends are excessive and affecting hair health
      Difficulty managing or styling hair despite home care
      For professional advice on damage repair and product recommendations
      ''';
    } else if (symptomsInput.contains('dry hair')) {
      response = '''
    Symptoms:
      Dull, lifeless, or brittle hair
      Split ends and breakage
      Frizzy texture or difficulty managing
      Scalp may feel dry or itchy
    Causes:
      Overwashing or using harsh shampoos
      Excessive heat styling (e.g., straightening, curling)
      Chemical treatments like dyeing or bleaching
      Sun exposure, chlorine, or saltwater damage
      Nutritional deficiencies or dehydration
    Medications:
      Hair Serums: Products with argan oil, keratin, or silicone to lock in moisture
      Prescription Shampoos: For scalp conditions causing dryness (e.g., dandruff)
    Natural Remedies:
      Apply coconut, argan, or olive oil as a deep-conditioning treatment
      Use a honey and yogurt mask for hydration and protein
      Rinse hair with aloe vera juice or diluted apple cider vinegar for moisture retention
      Avoid hot water; use lukewarm or cool water for rinsing
    Prevention Tips:
      Wash hair 2-3 times a week to retain natural oils
      Use sulfate-free shampoos and hydrating conditioners
      Limit heat styling and always use a heat protectant spray
      Wear a hat or scarf to shield hair from sun and wind damage
      Stay hydrated and consume foods rich in omega-3 fatty acids and biotin
    When to See a Doctor or Specialist:
      Persistent dryness despite home care
      Excessive hair breakage or hair loss
      Scalp issues like flaking, redness, or irritation
      For professional advice on underlying health conditions or treatments
      ''';
    } else if (symptomsInput.contains('gray hair')) {
      response = '''
    Symptoms: 
      Hair strands lose pigment and appear gray, silver, or white
      Gradual onset, starting with a few strands, progressing over time
    Causes:
      Natural aging (reduced melanin production)
      Genetic predisposition
      Stress or oxidative damage
      Nutritional deficiencies (e.g., B12, copper)
      Certain medical conditions (e.g., vitiligo, thyroid disorders)
    Medications:
      Hair Dyes: Permanent, semi-permanent, or natural options like henna
      Topical Melanin Enhancers: Experimental treatments (consult a dermatologist)
      Supplements: Vitamin B12, copper, or biotin if deficiencies are identified
    Natural Remedies:
      Apply coconut oil mixed with curry leaves for pigment maintenance (limited evidence)
      Use amla (Indian gooseberry) oil or powder to nourish the scalp and support hair health
      Black tea rinses can temporarily darken gray strands
      Add antioxidants to your diet (e.g., berries, leafy greens, nuts)
    Prevention Tips:
      Avoid smoking, which accelerates graying
      Manage stress with mindfulness practices like yoga or meditation
      Maintain a balanced diet rich in vitamins and minerals
      Use mild, sulfate-free shampoos to protect hair
    When to See a Doctor:
      Premature graying before the age of 20 (for Caucasians) or 30 (for other ethnic groups)
      Associated with hair loss, thinning, or scalp issues
      Concerns about underlying medical conditions or deficiencies
     ''';
    } else if (symptomsInput.contains('thin hair')) {
      response = '''
    Symptoms:
      Fine, limp hair that lacks volume
      Hair may appear sparse or thinning on the scalp
      Increased hair shedding or noticeable bald spots
    Causes:
      Genetic factors (hereditary hair thinning)
      Hormonal changes (e.g., menopause, thyroid issues)
      Nutritional deficiencies (e.g., protein, iron, biotin)
      Stress, illness, or certain medications
    Medications:
      Minoxidil (Rogaine): Over-the-counter treatment to promote hair growth
      Finasteride (Propecia): Prescription medication for male pattern baldness
      Nutritional Supplements: Biotin or iron if deficiencies are present
    Natural Remedies:
      Massage the scalp with oils (e.g., castor oil, rosemary oil) to promote circulation
      Use egg masks for added protein and nourishment
      Maintain a balanced diet rich in vitamins and minerals
    Prevention Tips:
      Avoid tight hairstyles that stress hair follicles
      Limit heat styling and chemical treatments
      Use volumizing shampoos and conditioners
      Get regular trims to maintain hair health
    When to See a Doctor:
      Sudden or excessive hair loss
      Persistent thinning despite home care
      Concerns about underlying health issues or hormonal imbalances
      ''';
    } else if (symptomsInput.contains('frizzy hair')) {
      response = '''
    Symptoms:
      Hair appears dry, unruly, and difficult to manage
      Flyaways or a rough texture
      Lack of shine or smoothness
    Causes:
      Humidity and environmental factors
      Lack of moisture in the hair
      Damage from heat styling, coloring, or chemical treatments
      Overwashing or using harsh shampoos
    Medications:
      Leave-In Conditioners: Products with moisturizing ingredients (e.g., argan oil, shea butter)
      Serums: Silicone-based serums to smooth and tame frizz (e.g., Moroccan oil)
    Natural Remedies:
      Apply coconut or olive oil to damp hair for hydration
      Use a mixture of honey and yogurt as a moisturizing mask
      Rinse with apple cider vinegar to improve shine and reduce frizz
    Prevention Tips:
      Limit heat styling and always use heat protectants
      Use sulfate-free shampoos and hydrating conditioners
      Avoid washing hair too frequently to retain natural oils
      Protect hair from humidity by using anti-frizz products
    When to See a Specialist:
      Persistent frizz despite using hair care products
      Significant hair damage or breakage
      Concerns about underlying scalp conditions
      ''';
    } else if (symptomsInput.contains('oily hair')) {
      response = '''
    Symptoms:
      Hair appears greasy or shiny shortly after washing
      Scalp may feel oily or dirty
      Hair can be limp or lack volume
    Causes:
      Overactive sebaceous glands producing excess oil
      Hormonal changes (e.g., puberty, menstruation)
      Improper washing techniques or using the wrong products
      Environmental factors (humidity, pollution)
    Medications:
      Medicated Shampoos: Salicylic acid or ketoconazole shampoos to reduce oiliness
      Dry Shampoo: Temporary solution to absorb excess oil between washes
    Natural Remedies:
      Use apple cider vinegar diluted with water as a rinse to balance scalp pH
      Apply lemon juice to the scalp to help control oil production
      Use tea tree oil mixed with carrier oil for its antibacterial properties
    Prevention Tips:
      Wash hair regularly (every 1-3 days) with a gentle, sulfate-free shampoo
      Avoid heavy conditioners or hair products that can add weight
      Rinse hair with cool water to help control oiliness
      Limit touching hair to avoid transferring oils from hands
    When to See a Doctor:
      Persistent oiliness despite regular washing
      Associated scalp issues like itching, redness, or flaking
      Concerns about hormonal imbalances or underlying skin conditions
''';
    } else if (symptomsInput.contains('itchy scalp')) {
      response = '''
    Symptoms:
      Persistent itching or scratching of the scalp
      Redness or irritation on the scalp
      Flaking or dandruff
      Hair loss in some cases (due to excessive scratching)
    Causes:
      Dandruff or seborrheic dermatitis
      Scalp psoriasis
      Allergic reactions to hair products (e.g., shampoos, dyes)
      Fungal infections (e.g., ringworm)
      Dry skin or lack of moisture
    Medications:
      Medicated Shampoos: Anti-dandruff shampoos containing zinc pyrithione, ketoconazole, or salicylic acid
      Topical Corticosteroids: Creams or lotions to reduce inflammation and itching
      Antihistamines: Oral medications for allergic reactions
    Natural Remedies:
      Apply aloe vera gel to soothe irritation
      Use coconut oil or olive oil to moisturize the scalp
      Rinse with apple cider vinegar diluted in water to restore pH balance
      Try tea tree oil diluted with a carrier oil for its antifungal properties
    Prevention Tips:
      Avoid using harsh or irritating hair products
      Maintain a regular washing schedule to keep the scalp clean
      Keep hair and scalp moisturized, especially in dry weather
      Manage stress, which can exacerbate scalp conditions
    When to See a Doctor:
      Persistent itching despite home treatments
      Severe redness, swelling, or pain on the scalp
      Symptoms accompanied by hair loss or visible scalp lesions
      Concerns about underlying skin conditions or infections
''';
    } else if (symptomsInput.contains('hair breakage')) {
      response = '''
    Symptoms
      Hair strands feel rough, brittle, or dry.
      Split ends or frayed hair
      Increased hair shedding or visible short broken strands
      Difficulty styling or maintaining hair
    Causes:
      Excessive heat styling (blow-drying, curling, straightening)
      Chemical treatments (coloring, perming, relaxing)
      Lack of moisture or hydration in hair
      Overwashing or using harsh shampoos
      Physical stress (tight hairstyles, excessive brushing)
    Medications:
      Deep Conditioning Treatments: Masks or treatments containing protein or moisture (e.g., keratin treatments)
      Leave-In Conditioners: Products designed to hydrate and protect hair
    Natural Remedies:
      Use coconut oil or olive oil as a pre-wash treatment to nourish hair
      Apply honey and yogurt masks for moisture and strength
      Rinse hair with aloe vera juice for hydration and shine
    Prevention Tips:
      Limit heat styling and always use heat protectant sprays
      Avoid tight hairstyles that can pull on hair strands
      Use sulfate-free shampoos and hydrating conditioners
      Get regular trims to remove split ends and damaged hair
    When to See a Doctor or Specialist:
      Persistent breakage despite proper care
      Significant hair loss or thinning
      Concerns about underlying health issues affecting hair health
''';
    } else if (symptomsInput.contains('heat damage')) {
      response = '''
    Symptoms:
      Hair appears dry, frizzy, or brittle
      Split ends and breakage are common
      Dull or lackluster hair, losing its natural shine
      Difficulty styling hair due to texture changes
    Causes:
      Excessive use of heat styling tools (e.g., blow dryers, straighteners, curling irons)
      High heat settings used without protection
      Infrequent use of conditioning treatments
      Lack of moisture or hydration in the hair
    Medications:
      Deep Conditioning Treatments: Masks with protein or moisturizing ingredients (e.g., keratin treatments)
      Leave-In Conditioners: Products designed to hydrate and protect hair after heat exposure
    Natural Remedies:
      Apply coconut or argan oil to damp hair to nourish and restore moisture
      Use an avocado or banana mask for added hydration and nourishment
      Rinse with aloe vera juice to soothe and condition the hair
    Prevention Tips:
      Limit heat styling to a few times per week and allow hair to air dry when possible
      Use heat protectant sprays or serums before applying any heat
      Choose lower heat settings on styling tools when possible
      Maintain a regular hair care routine that includes hydration and protein treatments
    When to See a Specialist:
      Persistent damage despite proper care and protection
      Significant hair loss or thinning associated with heat styling
     Concerns about underlying hair or scalp conditions
''';
    } else if (symptomsInput.contains('joint pains')) {
      response = '''
    Symptoms:
      Pain or discomfort in one or more joints
      Swelling, redness, or warmth around the joint
      Stiffness or reduced range of motion
      Clicking or popping sounds during movement
    Medications:
      Pain Relievers:ibuprofen or acetaminophen
      Topical Creams: 
         Volini Pain Relief Gel
         Icy Hot Cream
         Tiger Balm
         Moov Pain Relief Cream
         Deep Heat Rub
         Biofreeze Pain Relief Gel
         BenGay Pain Relief Cream
         Relispray
    Natural Remedies:
      Apply hot or cold compresses to reduce pain and inflammation
      Use turmeric or ginger (in food or supplements) for their anti-inflammatory properties
      Perform gentle stretching or yoga to improve flexibility and reduce stiffness
      Massage with essential oils like eucalyptus or peppermint oil
    Prevention Tips:
      Maintain a healthy weight to reduce stress on joints
      Stay active with low-impact exercises like swimming or walking
      Use proper ergonomics while working or lifting heavy objects
      Consume a diet rich in calcium, vitamin D, and omega-3 fatty acids
    When to See a Doctor:
      Persistent or severe joint pain
      Swelling, redness, or warmth that doesn’t improve
      Joint pain accompanied by fever or unexplained weight loss
      Difficulty performing daily activities due to joint discomfort
''';
    } else if (symptomsInput.contains('balanced diet')) {
      response = '''
Breakfast:
    Oats with fruits (like bananas, berries) and nuts
    A smoothie made with spinach, banana, almond milk, and a scoop of protein powder
Lunch:
    Grilled chicken or tofu with quinoa and steamed vegetables (broccoli, carrots, or spinach)
    A large salad with mixed greens, chickpeas, tomatoes, cucumber, olive oil, and lemon dressing
Snack:
    A handful of almonds or walnuts
    Greek yogurt with honey and a sprinkle of chia seeds
Dinner:
    Grilled salmon with brown rice and steamed asparagus
    Stir-fried tofu with vegetables and a side of sweet potatoes
Drinks:
    Plenty of water throughout the day
    Green tea or herbal teas
''';
    } else if (symptomsInput.contains('weight loss diet')) {
      response = '''
  Focus on a low-calorie, nutrient-dense diet that keeps you full and satisfied
Breakfast:
    Scrambled eggs with spinach and a slice of whole-grain toast
    Chia pudding with almond milk and a few berries
Lunch:
    A big salad with lettuce, cucumbers, cherry tomatoes, avocado, lean turkey or chicken breast, and a vinaigrette dressing
    Grilled shrimp with a side of roasted vegetables like zucchini, bell peppers, and a little olive oil
Snack:
    Carrot sticks with hummus
    A boiled egg and a few slices of cucumber
Dinner:
    Grilled chicken with steamed broccoli and cauliflower rice
    A vegetable stir-fry with tofu and a small serving of brown rice
Drinks:
    Drink water with lemon or herbal teas to avoid sugary drinks
''';
    } else if (symptomsInput.contains('muscle gain diet')) {
      response = '''
Focus on protein-rich foods to promote muscle repair and growth
Breakfast:
    Scrambled eggs with spinach, bell peppers, and whole-grain toast
    A protein smoothie with whey protein, almond milk, oats, banana, and peanut butter
Lunch:
    Grilled chicken breast with quinoa, a side of mixed vegetables, and avocado
    A tuna salad with olive oil, mixed greens, and chickpeas
Snack:
    Greek yogurt with granola and almonds
    A protein bar or protein shake
Dinner:
    Lean beef steak or turkey breast with sweet potatoes and steamed broccoli
    A whole-grain pasta dish with grilled chicken, spinach, and tomato sauce
Drinks:
    Protein shakes post-workout
    Plenty of water throughout the day to stay hydrated
''';
    } else if (symptomsInput.contains('vegetarian diet')) {
      response = '''
A well-rounded vegetarian diet can be rich in plant-based protein, fiber, and essential nutrients
Breakfast:
    Overnight oats with chia seeds, almond milk, and mixed berries
    A smoothie with spinach, banana, flaxseeds, almond butter, and almond milk
Lunch:
    Quinoa and chickpea salad with spinach, cucumber, red onion, and lemon dressing
    Lentil soup with a side of whole-grain bread
Snack:
    A handful of nuts (almonds, cashews)
    Sliced avocado with whole-grain crackers
Dinner:
    Stir-fried tofu with mixed vegetables (broccoli, bell peppers, carrots) and brown rice
    Vegetarian chili with kidney beans, black beans, and a side of cornbread
Drinks:
    Herbal teas, like chamomile or peppermint
    Freshly squeezed vegetable juice (carrot, spinach, cucumber)
''';
    } else if (symptomsInput.contains('gulten free diet')) {
      response = '''
Avoid gluten and focus on naturally gluten-free foods
Breakfast:
    Gluten-free oats with almond butter, chia seeds, and sliced bananas
    Smoothie with coconut milk, berries, spinach, and chia seeds
Lunch:
    Grilled chicken or salmon with quinoa and roasted vegetables
    A salad with grilled chicken, quinoa, mixed greens, and balsamic vinaigrette
Snack:
    Rice cakes with almond butter
    Fresh fruit (like apple or berries) with a handful of nuts
Dinner:
    Grilled shrimp or chicken with a side of roasted sweet potatoes and steamed broccoli
    Gluten-free pasta with marinara sauce and grilled vegetables
Drinks:
    Water, herbal teas, or coconut water
''';
    } else if (symptomsInput.contains('keto diet')) {
      response = '''
Focus on high-fat, low-carb foods, which help the body burn fat for fuel
Breakfast:
    Scrambled eggs with avocado and spinach cooked in olive oil or butter
    Keto smoothie with coconut milk, spinach, chia seeds, and almond butter
Lunch:
    Grilled chicken with a large salad (lettuce, cucumber, cheese, avocado, olive oil, and lemon dressing)
    Salmon with sautéed spinach and a side of cauliflower mash
Snack:
    A handful of mixed nuts (macadamia, walnuts, almonds)
    Cheese slices with cucumber or celery sticks
Dinner:
    Steak or grilled pork with a side of roasted Brussels sprouts or asparagus
    Zucchini noodles with creamy pesto and grilled chicken
Drinks:
    Water with lemon
    Coffee with cream (without sugar)
 ''';
    } else if (symptomsInput.contains('tips')) {
      response = '''
    Hydrate: Drink a glass of water as soon as you wake up
    Balanced Breakfast: Include protein, healthy fats, and fiber
    Prioritize Protein: Add protein to every meal
    Stay Active: Aim for 30 minutes of activity daily
    Portion Control: Be mindful of portion sizes
    Smart Snacks: Choose healthy options like fruits and nuts
    Add Greens: Include leafy greens in every meal
    Take Breaks: Stand and stretch every 30 minutes
    Good Posture: Maintain proper posture throughout the day
    Don’t Skip Meals: Eat regularly to maintain energy
    Mindful Eating: Focus on your food and chew slowly
    Sleep Well: Aim for 7-8 hours of sleep
    Practice Gratitude: Reflect on things you're grateful for
    Avoid Processed Foods: Stick to whole, nutritious foods
    Track Progress: Keep a journal or use an app for accountability
    Be Consistent: Make small, sustainable changes for long-term success
''';
    } else {
      response = '''
      We’re sorry if this issue needs proper medical attention beyond home care 
      If symptoms persist or there is severe discomfort, kindly consult a qualified doctor 
      Timely treatment makes a big difference, and we apologise for any inconvenience.''';
    }
    print("Response generated: $response");

    // Add the chatbot's response to the message list
    addMessage(response, Messagetype.bot);
    speak(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Healthcare Chatbot',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 10,
            color: Colors.teal,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return chatBubble(
                          message: msg["message"],
                          isUser: msg["isUser"],
                        );
                      },
                    ),
                  ),
                  TextField(
                    onSubmitted: (text) {
                      // Manually add a message when the user types and presses enter
                      addMessage(text, Messagetype.user);
                      CheckSymptoms(text);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your symptoms...',
                      suffixIcon: IconButton(
                        icon: Icon(isListening ? Icons.mic_off : Icons.mic),
                        onPressed: () {
                          if (isListening) {
                            stopListening();
                          } else {
                            startListening();
                          }
                        },
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to display chat bubbles
  Widget chatBubble({required String message, required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.limeAccent[400] : Colors.limeAccent[700],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: TextStyle(color: isUser ? Colors.black : Colors.black87),
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
