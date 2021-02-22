package fr.sparna.rdf.shacl.diagram;

import java.io.File;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.Resource;
import org.apache.jena.vocabulary.RDF;
import org.topbraid.shacl.vocabulary.SH;

public class ShaclPlantUmlWriter {


	public String writeInPlantUml(Model shaclGraph) {

		List<Resource> nodeShapes = shaclGraph.listResourcesWithProperty(RDF.type, SH.NodeShape).toList();

		// 1. Lire toutes les box
		ArrayList<PlantUmlBox> planumlvalue = new ArrayList<>();
		ArrayList<String> shaclnode = new ArrayList<>();
		for (Resource nodeShape : nodeShapes) {
			shaclnode.add(nodeShape.getLocalName());
			PlantUmlBox dbShacl = new PlantUmlBox(nodeShape);
			planumlvalue.add(dbShacl);
		} 
		
		// 2. Une fois qu'on a toute la liste, lire les proprietes
		for (PlantUmlBox aBox : planumlvalue) {
			aBox.readProperties(aBox.getNodeShape(), planumlvalue);
		}

		List<String> sourceuml = new ArrayList<>();
		String Auxpackage = "";
		boolean  close_package=false;
		planumlvalue.sort(Comparator.comparing(PlantUmlBox::getPackageName));
		
		for (PlantUmlBox plantUmlBox : planumlvalue) {
			
			if (plantUmlBox.getPackageName() != "" & !Auxpackage.equals(plantUmlBox.getPackageName())) {
				if (close_package) {
					sourceuml.add("}\n");
				}
				sourceuml.add("namespace "+plantUmlBox.getPackageName()+" "+"{\n");
				Auxpackage = plantUmlBox.getPackageName();
				
				close_package = true;
				if (plantUmlBox.getNametargetclass() != null) {
					sourceuml.add("Class"+" "+"\""+plantUmlBox.getNameshape()+"\""+" "+"<"+plantUmlBox.getNametargetclass()+">"+"\n");
				}else {
					sourceuml.add("Class"+" "+"\""+plantUmlBox.getNameshape()+"\""+"\n");
				}
			} else {
				if (plantUmlBox.getNametargetclass() != null) {
					sourceuml.add("Class"+" "+"\""+plantUmlBox.getNameshape()+"\""+" "+"<"+plantUmlBox.getNametargetclass()+">"+"\n");
				}else {
					sourceuml.add("Class"+" "+"\""+plantUmlBox.getNameshape()+"\""+"\n");
				}
			}
			
			PlantUmlRenderer renderer = new PlantUmlRenderer(plantUmlBox.getNameshape());
			for (PlantUmlProperty plantUmlproperty : plantUmlBox.getProperties()) {
				sourceuml.add(renderer.render(plantUmlproperty));
			}
		}
		
		if (close_package) {
			sourceuml.add("}\n");
		}
		
		String source = "@startuml\n";
		source +="!define LIGHTORANGE\n";
		
		//skinparam linetype ortho        // l'instruction cr�er des lignes droits  
		//source +="!includeurl https://raw.githubusercontent.com/Drakemor/RedDress-PlantUML/master/style.puml\n\n";
		
		source += "skinparam componentStyle uml2\n";
		source += "skinparam wrapMessageWidth 100\n";
		source += "skinparam ArrowColor #Maroon\n\n";
		


		for (String code : sourceuml) {
			source += code;
		}
		source += "hide circle\n";
		source += "hide methods\n";
		source += "@enduml\n";


		return source;
	}
	


}
