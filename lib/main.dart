import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//TODO: Sig hvilket stof der ikke kan findes. måske åben en tabel.

void main() {
  runApp(const MyApp());
}

// The class for a substance in the equation, a substance has a coeff, name and state.
class Substance {
  Substance(this.coefficient, this.nameAndState);

  int coefficient;
  String nameAndState;
}

// Defines the design mostly
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Standardentalpi og -Entropi udregner',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Standardentalpi og -entropi udregner'),
    );
  }
}
// makes the title at the top
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = "Resultat";
  String reactantString = "";
  String productString = "";
  String tempString = "";
  var reactantController = TextEditingController();
  var temperatureController = TextEditingController();
  var productController = TextEditingController();
  double R = 8.314; // J / mol K


  // TODO: Get these values from a JSON file
  // list of the standard S from Databog fysik kemi
  Map<String, double> entropyTable = {
    'Li*(aq)': 12.24,
    'Li2CO3(s)': 90.37,
    'CO32-(aq)': -50.0,
    'Ag(s)': 42.55,
    'Ag*(aq)': 73.45,
    'AgCl(s)': 96.25,
    'AgI(s)': 115.53,
    'Ba(OH)2.8H2O(s)': 427,
    'BaCl2.2H2O(s)': 202.0,
    'C(s,grafit)': 5.74,
    'C(s,diamant)': 2.377,
    'Ca2*(aq)':-53.1,
    'CH4(g)': 186.3,
    'C2H4(g)': 219.3,
    'C7H16(l)': 326.1,
    'CH3OH(l)': 126.8,
    'CH3OH(g)': 239.9,
    'CH3CH2OH(l)': 160.7,
    'CH3CH2OH(g)': 281.6,
    'CO(g)': 197.66,
    'CO2(g)': 213.785,
    'CaCO3(s)': 92.9,
    'CaCl2(s)':108.4,
    'CaO(s)': 38.1,
    'Ca(OH)2': 83.4,
    'Cl-(aq)': 56.60,
    'CrO42-(aq)': 50.2,
    'H2(g)': 130.68,
    'H*(aq)': 0.0,
    'H3O*(aq)': 69.95,
    'H2O(l)': 69.95,
    'H2O(g)': 188.8,
    'HCl(g)': 186.9,
    'HI(g)': 206.44,
    'I2(s)': 116.14,
    'I-(aq)': 106.45,
    'N2(g)': 191.61,
    'NH3(g)': 192.8,
    'NH4*(aq)': 113.4,
    'NH4Cl(s)': 94.6,
    'NH4NO3(s)': 151.1,
    'NO(g)': 210.8,
    'NO2(g)': 240.1,
    'N2O4(g)': 304.3,
    'NO3-(aq)': 146.4,
    'Na(s)': 51.30,
    'Na*(aq)': 58.45,
    'NaCl(s)': 72.1,
    'O2(g)': 205.15,
    'OH-(aq)': -10.90,
    'SO2(g)': 248.23,
    'TiO2(s)': 50.62,
    'Cl2(g)': 223.08,
    'TiCl4(g)': 354.8,
    'SO3(g)': 256.83
  };

  // List of the standard H from Databog fysik kemi
  Map<String, double> enthalpyTable = {
    'Li*(aq)': -278.47,
    'Li2CO3(s)': -1215.6,
    'CO32-(aq)': -675.23,
    'Ag(s)': 0.0,
    'Ag*(aq)': 105.79,
    'AgCl(s)': -127.01,
    'AgI(s)': -61.87,
    'Ba(OH)2.8H2O(s)': -3342.2,
    'BaCl2.2H2O(s)': -1456.9,
    'C(s,grafit)': 0.0,
    'C(s,diamant)': 1.895,
    'Ca2*(aq)':-543.0,
    'CH4(g)': -74.6,
    'C2H4(g)': 52.30,
    'C7H16(l)': -224.2,
    'CH3OH(l)': -239.2,
    'CH3OH(g)': -201.0,
    'CH3CH2OH(l)': -277.6,
    'CH3CH2OH(g)': -234.8,
    'CO(g)': -110.53,
    'CO2(g)': -393.51,
    'CaCO3(s)': -1206.92,
    'CaCl2(s)':-795.42,
    'CaO(s)': -634.92,
    'Ca(OH)2': -985.2,
    'Cl-(aq)': -167.08,
    'CrO42-(aq)': -881.15,
    'H2(g)': 0.0,
    'H*(aq)': 0.0,
    'H3O*(aq)': -285.83,
    'H2O(l)': -285.83,
    'H2O(g)': -241.8,
    'HCl(g)': -92.3,
    'HI(g)': 25.94,
    'I2(s)': 0.0,
    'I-(aq)': -56.78,
    'N2(g)': 0.0,
    'NH3(g)': -45.5,
    'NH4*(aq)': -132.4,
    'NH4Cl(s)': -314.6,
    'NH4NO3(s)': -365.3,
    'NO(g)': 91.2,
    'NO2(g)': 33.1,
    'N2O4(g)': 11.4,
    'NO3-(aq)': -207,
    'Na(s)': 0.0,
    'Na*(aq)': -240.34,
    'NaCl(s)': -411.2,
    'O2(g)': 0.0,
    'OH-(aq)': -230.01,
    'SO2(g)': -296.81,
    'TiO2(s)': -944.0,
    'Cl2(g)': 0.0,
    'TiCl4(g)': -763.2,
    'SO3(g)': -395.72
  };

  // General look of an error popup
  AlertDialog errorDialog (String msg){
    return AlertDialog(
        title: const Text("Fejl"),
        content: Text( msg),
        actions: [TextButton( onPressed:  ()  {Navigator.of(context).pop();}, child: const Text("Jeg retter det"))]
    );
  }

  // Analyses the reactant and product strings and returns the substances involved.
  List<Substance> stringAnalysis(String str) {
    // Remove any leading or trailing spaces
    str = str.trim();

    // Split the string by plus as this seperates substances
    List<String> substances = str.split('+');
    // Makes an empty substance list. Here called reactants eventhough its a little confusing.
    List<Substance> reactants = [Substance(1, 'n g')];
    reactants.clear();

    // for each element from the string do this
    for (var element in substances) {
      element = element.trim();

      // The substance is comprised of coeff and namestate. This is seperated by space
      List<String> parts = element.split(' ');

      // If the element is formatted wrong try and help user. And don't continue
      if (parts.length != 2) {
        String doThis = "";
        if (parts.length < 2){
          doThis = "Du mangler at skrive enten koefficent eller stof ved: ";
        } else {
          doThis = "Du har skrevet for meget (Måske der er mellemrum mellem stof og tilstandsform) ved: ";
        }
        showDialog(context: context, builder: (_) => errorDialog(doThis + element));
        return reactants;
      }


      int coefficient = 1;
      String nameAndState = "";

      // first try and parse coefficent and tell user if wrong
      try {
        coefficient = int.parse(parts[0]);
      } on FormatException catch (_) {
        showDialog(context: context, builder: (_) => errorDialog("Koefficenten er forkert skrevet skal være et heltal her: $element. Koefficenten der blev indtastet er ${parts[0]}"));
        return reactants;
      }
      // Hereafter we check if the substance is present in our tables
      if(entropyTable.containsKey(parts[1])){
        nameAndState = parts[1];
      } else {
        showDialog(context: context, builder: (_) => errorDialog("Stoffet ${parts[1]} findes ikke i databasen"));
        return reactants;
      }
      
      reactants.add(Substance(coefficient, nameAndState));
    }

    return reactants;
  }

  List<double> calculateSide(List<Substance> substances) {
    double enthalpy = 0;
    double entropy = 0;

    for (Substance element in substances) {
      String name = element.nameAndState;
      double? tableValueEnthalpy = 0;
      double? tableValueEntropy = 0;

      tableValueEnthalpy = enthalpyTable[name];
      tableValueEntropy = entropyTable[name];

      enthalpy += element.coefficient * tableValueEnthalpy!;
      entropy += element.coefficient * tableValueEntropy!;
    }

    return [enthalpy, entropy];
  }

  List<double> calculate(List<Substance> reactants, List<Substance> products) {
    List<double> reactantValues = calculateSide(reactants);
    List<double> productValues = calculateSide(products);


    double? temp = double.tryParse(tempString);
    temp ??= 298.15;

    double enthalpy = productValues[0] - reactantValues[0];
    double entropy = productValues[1] - reactantValues[1];
    double gibbs = enthalpy - (entropy /1000.0) * temp ;

    double temperatureWhereZero = (enthalpy * 1000.0) / (entropy);

    double equilibrium = exp( ((-enthalpy * 1000.0)/R) * (1/temp) + (entropy / R) );

    return [enthalpy, entropy, gibbs, temperatureWhereZero, equilibrium];
  }

  String makeString(String type) {
    List<Substance> reactants = stringAnalysis(reactantString);
    List<Substance> products = stringAnalysis(productString);

    List<double> values = calculate(reactants, products);

    String enthalpyDownString = '';
    String entropyDownString = '';

    for (Substance element in reactants) {
      String name = element.nameAndState;

      enthalpyDownString += "${enthalpyTable[name]}  ";
      entropyDownString += "${entropyTable[name]}  ";
    }
    enthalpyDownString +="  -->  ";
    entropyDownString +="  -->  ";
    for (Substance element in products) {
      String name = element.nameAndState;

      enthalpyDownString += "${enthalpyTable[name]}  ";
      entropyDownString += "${entropyTable[name]}  ";
    }

    String string = "";

    if (type == "entalpi") {
      string = "$reactantString  -->  $productString\n$enthalpyDownString\n";
      string += "ΔHӨ = ${values[0].toStringAsFixed(2)} kJ/mol";
    } else if (type == "entropi") {
      string = "$reactantString  -->  $productString\n$entropyDownString\n";
      string += "ΔSӨ = ${values[1].toStringAsFixed(2)} J/(K * mol)";
    } else if (type == "gibbs"){
      string = "For reaktionen $reactantString  -->️  $productString gælder\n";
      string += "ΔG = ${values[2].toStringAsFixed(2)} kJ / mol\n";
      string += "Fordi ΔG = ΔHӨ - ΔSӨ * T = (${values[0].toStringAsFixed(2)} kJ / mol) - (${values[1].toStringAsFixed(2)} J/K * mol) * ";
      if (temperatureController.text == ""){ string += "298.15"; } else { string += temperatureController.text; } string += " K \n\n";
      string += "ΔG er 0 ved denne temperatur ${values[3].toStringAsFixed(2)} K \n";
      string += "Fordi T = (ΔHӨ * 10^3) / ΔSӨ = (${values[0].toStringAsFixed(2)} kJ/mol * 10^3) / ${values[1].toStringAsFixed(2)} J/K * mol \n\n";
      string += "Ligevægten(k) ved denne temperatur er ${values[4]} (Husk at finde en enhed) \n";
      string += "Fordi k = exp(((-ΔHӨ * 10^3)/R) * (1/T) + (ΔSӨ / R)) = exp(((-(${values[0].toStringAsFixed(2)}) * 10^3)/8.314) * (1/ ";
      if (temperatureController.text == ""){ string += "298.15"; } else { string += temperatureController.text; }
      string += ") + (${values[1].toStringAsFixed(2)} / 8.314 )) \n";
    }

    return string;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            // Forklaring
            const Text(
              'Skriv på denne form (læg mærke til ioner og mellemrum. Derudover kopieres svaret automatisk til din udklipsholder): \n'
              '2 Na*(aq) + 2 OH-(aq) + 3 Ba(OH)2.8H2O(s)\n',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),

            // Reaktanter
            TextField(
              controller: reactantController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Reaktanter'),
              onChanged: (txt) {
                reactantString = txt;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            // Produkter
            TextField(
              controller: productController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Produkter'),
              onChanged: (txt) {
                productString = txt;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            // Temperatur
            TextField(
              controller: temperatureController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Temperatur i K (Kun til Gibbs)',
              ),
              onChanged: (txt) {
                tempString = txt;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Entalpi Knap
                TextButton(
                    onPressed: () {
                      setState(() {
                        String msg = makeString("entalpi");
                        result = msg;
                        Clipboard.setData(ClipboardData(text: msg));
                      });
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20)),
                    child: const Text('Entalpi')),
                const SizedBox(
                  width: 10,
                ),
                // Entropi Knap
                TextButton(
                    onPressed: () {
                      setState(() {
                        String msg = makeString("entropi");
                        result = msg;
                        Clipboard.setData(ClipboardData(text: msg));
                      });
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20)),
                    child: const Text('Entropi')),
                const SizedBox(
                  width: 10,
                ),
                // Entropi Knap
                TextButton(
                    onPressed: () {
                      setState(() {
                        String msg = makeString("gibbs");
                        result = msg;
                        Clipboard.setData(ClipboardData(text: msg));
                      });
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20)),
                    child: const Text("Gibb's")),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    reactantController.clear();
                    productController.clear();
                  });
                },
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                child: const Text('Slet input')),
            // Resultatet
            SelectableText(result, style: const TextStyle(fontSize: 16))
          ],
        ),
      ),
    );
  }
}
