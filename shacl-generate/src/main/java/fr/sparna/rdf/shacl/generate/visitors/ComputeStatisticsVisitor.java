package fr.sparna.rdf.shacl.generate.visitors;

import java.util.List;
import java.util.stream.Collectors;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.RDFList;
import org.apache.jena.rdf.model.RDFNode;
import org.apache.jena.rdf.model.Resource;
import org.apache.jena.shacl.vocabulary.SHACLM;
import org.apache.jena.vocabulary.DCAT;
import org.apache.jena.vocabulary.DCTerms;
import org.apache.jena.vocabulary.RDF;
import org.apache.jena.vocabulary.RDFS;
import org.apache.jena.vocabulary.VOID;
import org.apache.jena.vocabulary.XSD;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import fr.sparna.rdf.shacl.generate.ShaclGenerator;
import fr.sparna.rdf.shacl.generate.ShaclGeneratorDataProviderIfc;

public class ComputeStatisticsVisitor extends DatasetAwareShaclVisitorBase implements ShaclVisitorIfc {

	private static final Logger log = LoggerFactory.getLogger(ComputeStatisticsVisitor.class);
	
	private Model model;
	private String datasetUri;
	private boolean addToDescription = false;
	
	// In the case of this visitor the output model can be different from the input model
	private Model outputModel;

	
	public ComputeStatisticsVisitor(
			ShaclGeneratorDataProviderIfc dataProvider,
			Model outputModel,
			String datasetUri,
			boolean addToDescription
	) {
		super(dataProvider);
		this.datasetUri = datasetUri;
		this.outputModel = outputModel;
		this.addToDescription = addToDescription;
	}
	
	@Override
	public void visitModel(Model model) {
		this.model = model;
		
		// create the Dataset
		outputModel.add(outputModel.createResource(this.datasetUri), RDF.type, VOID.Dataset);
		
		// count the total number of triples
		int count = this.dataProvider.countTriples();
		if(count >= 0) {
			log.debug("(count) dataset '{}' gets void:triples '{}'", this.datasetUri, count);
			// assert number of triples on the Dataset
			outputModel.add(outputModel.createResource(this.datasetUri), VOID.triples, outputModel.createTypedLiteral(count));
		}
		
		// add void + dct namespace
		outputModel.setNsPrefix("void", VOID.NS);
		outputModel.setNsPrefix("dct", DCTerms.NS);
		outputModel.setNsPrefix("xsd", XSD.NS);
		outputModel.setNsPrefix("dcat", DCAT.NS);
	}

	@Override
	public void visitOntology(Resource ontology) {
		// link Dataset to Ontology
		// TODO : could be a SHACL property ?
		outputModel.add(outputModel.createResource(this.datasetUri), DCTerms.conformsTo, ontology);
		
		// append to description
		if(this.addToDescription) {
			ShaclGenerator.concatOnProperty(
					ontology,
					DCTerms.abstract_,
					outputModel.createResource(this.datasetUri).getRequiredProperty(VOID.triples).getInt()+" triples in the dataset.",
					"en"
			);
		}
	}

	@Override
	public void visitNodeShape(Resource aNodeShape) {
		// link it to Dataset
		// TODO : this is not necessarily a classPartition, depending on target of shape
		String partitionUri = buildPartitionUri(this.datasetUri,aNodeShape,this.model);
		outputModel.add(outputModel.createResource(this.datasetUri), VOID.classPartition, model.createResource(partitionUri));
		// TODO : not necessarily a void:class predicate
		outputModel.add(outputModel.createResource(partitionUri), VOID._class, aNodeShape.getRequiredProperty(SHACLM.targetClass).getObject());
		
		// link class partition to NodeShape
		outputModel.add(outputModel.createResource(partitionUri), DCTerms.conformsTo, aNodeShape);
		
		
		// count number of instances
		// TODO : this requires to interpret the target of the Shape
		int count = this.dataProvider.countInstances(aNodeShape.getRequiredProperty(SHACLM.targetClass).getObject().asResource().getURI());
		if(count >= 0) {
			log.debug("(count) node shape '{}' gets void:entities '{}'", aNodeShape.getURI(), count);
			// assert number of triples
			outputModel.add(outputModel.createResource(partitionUri), VOID.entities, model.createTypedLiteral(count));
			// append to description
			if(this.addToDescription) {
				ShaclGenerator.concatOnProperty(
						aNodeShape,
						RDFS.comment,
						count+" instances",
						"en"
				);
			}
		}
	}

	@Override
	public void visitPropertyShape(Resource aPropertyShape, Resource aNodeShape) {
		// get corresponding class + property partition
		Resource classPartition = outputModel.createResource(buildPartitionUri(this.datasetUri,aNodeShape,this.model));
		Resource propertyPartition = outputModel.createResource(buildPartitionUri(this.datasetUri,aPropertyShape,this.model));
		
		// assert void:property on the property partition
		outputModel.add(propertyPartition, VOID.property, aPropertyShape.getRequiredProperty(SHACLM.path).getObject());
		
		// link property partition to class partition 
		outputModel.add(classPartition, VOID.propertyPartition, propertyPartition);
		
		// link property partition to PropertyShape
		outputModel.add(propertyPartition, DCTerms.conformsTo, aPropertyShape);

		String propertyPath = renderSparqlPropertyPath(aPropertyShape.getRequiredProperty(SHACLM.path).getObject().asResource());
		
		// count number of triples
		int count = this.dataProvider.countStatements(
				aNodeShape.getRequiredProperty(SHACLM.targetClass).getObject().asResource().getURI(),
				propertyPath
		);
		
		// assert void:triples
		log.debug("(count) property shape '{}' gets void:triples '{}'", aPropertyShape.getURI(), count);
		outputModel.add(propertyPartition, VOID.triples, model.createTypedLiteral(count));
		
		// count number of distinct objects
		int countDistinctObjects = this.dataProvider.countDistinctObjects(
				aNodeShape.getRequiredProperty(SHACLM.targetClass).getObject().asResource().getURI(),
				propertyPath
		);
		
		// assert void:distinctObjects
		log.debug("(count) property shape '{}' gets void:distinctObjects '{}'", aPropertyShape.getURI(), countDistinctObjects);
		outputModel.add(propertyPartition, VOID.distinctObjects, model.createTypedLiteral(countDistinctObjects));
		
		// append to description
		if(this.addToDescription) {
			ShaclGenerator.concatOnProperty(
					aPropertyShape,
					SHACLM.description,
					count+" occurences and "+countDistinctObjects+" distinct values",
					"en"
			);
		}
	}

	@Override
	public void leaveModel(Model model) {
		
	}
	
	protected boolean nodeShapeHasOtherPropertyShapeWithSamePath(Resource aPropertyShape, Resource aNodeShape) {
		// read sh:path
		String path = aPropertyShape.getRequiredProperty(SHACLM.path).getObject().asResource().getURI();
		
		// lookup property shapes with same path
		List<RDFNode> otherPropertyShapesWithSamePath = aNodeShape.listProperties(SHACLM.property)
			.filterDrop(statement -> {return statement.getObject().equals(aPropertyShape);})
			.toList().stream().map(statement -> statement.getObject()).collect(Collectors.toList());
		
		return otherPropertyShapesWithSamePath.size() > 0;
	}
	
	private static String buildPartitionUri(String datasetUri, Resource shape, Model shacl) {
		// extract local name of shape URI
		String localName = shape.getLocalName();
		// concat local name to datasetUri
		String partitionUri = datasetUri+"/"+"partition"+"_"+localName;
		return partitionUri;
	}
	
	public static String renderSparqlPropertyPath(Resource r) {
		if(r == null) return "";
		
		if(r.isURIResource()) {
			return "<"+r.getURI()+">";
		} else if(r.canAs(RDFList.class)) {
			List<RDFNode> l = r.as(RDFList.class).asJavaList();
			return l.stream().map(i -> renderSparqlPropertyPath(i.asResource())).collect(Collectors.joining("/"));
		} else if(r.hasProperty(SHACLM.alternativePath)) {
			Resource alternatives = r.getPropertyResourceValue(SHACLM.alternativePath);
			RDFList rdfList = alternatives.as( RDFList.class );
			List<RDFNode> pathElements = rdfList.asJavaList();
			return pathElements.stream().map(p -> renderSparqlPropertyPath((Resource)p)).collect(Collectors.joining("|"));
		} else if(r.hasProperty(SHACLM.inversePath)) {
			Resource value = r.getPropertyResourceValue(SHACLM.inversePath);
			if(value.isURIResource()) {
				return "^"+renderSparqlPropertyPath(value);
			}
			else {
				return "^("+renderSparqlPropertyPath(value)+")";
			}
		} else if(r.hasProperty(SHACLM.zeroOrMorePath)) {
			Resource value = r.getPropertyResourceValue(SHACLM.zeroOrMorePath);
			if(value.isURIResource()) {
				return renderSparqlPropertyPath(value)+"*";
			}
			else {
				return "("+renderSparqlPropertyPath(value)+")*";
			}
		} else if(r.hasProperty(SHACLM.oneOrMorePath)) {
			Resource value = r.getPropertyResourceValue(SHACLM.oneOrMorePath);
			if(value.isURIResource()) {
				return renderSparqlPropertyPath(value)+"+";
			}
			else {
				return "("+renderSparqlPropertyPath(value)+")+";
			}
		} else {
			return null;
		}
	}


}
