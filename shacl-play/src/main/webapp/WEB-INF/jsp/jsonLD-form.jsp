<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!-- setup the locale for the messages based on the language in the session -->
<fmt:setLocale
	value="${sessionScope['fr.sparna.rdf.shacl.shaclplay.SessionData'].userLocale.language}" />
<fmt:setBundle basename="fr.sparna.rdf.shacl.shaclplay.i18n.shaclplay" />

<c:set var="data" value="${requestScope['ConvertFormData']}" />

<html>
	<head>
		<title><fmt:message key="window.app" /></title>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		
		<!-- Font Awesome -->
		<link rel="stylesheet" href="<c:url value="/resources/fa/css/all.min.css" />">
		
		<link rel="stylesheet" href="<c:url value="/resources/MDB-Free/css/bootstrap.min.css" />">
		<link rel="stylesheet" href="<c:url value="/resources/MDB-Free/css/mdb.min.css" />">
		<link rel="stylesheet" href="<c:url value="/resources/jasny-bootstrap/jasny-bootstrap.min.css" />" />
		<link rel="stylesheet" href="<c:url value="/resources/css/shacl-play.css" />" />
		
		<script type="text/javascript">
	
			function enabledShapeInput(selected) {
				document.getElementById('shapesSource-' + selected).checked = true;
				document.getElementById('inputShapeUrl').disabled = selected != 'inputShapeUrl';
				//document.getElementById('inputShapeCatalog').disabled = selected != 'inputShapeCatalog';
				document.getElementById('inputShapeFile').disabled = selected != 'inputShapeFile';
				//document.getElementById('inputShapeInline').disabled = selected != 'inputShapeInline';
				
			}
		</script>


	</head>
	<body>

		<jsp:include page="navbar.jsp">
			<jsp:param name="active" value="context" />
		</jsp:include>

		<div class="container-fluid">
			<div class="row justify-content-md-center">
				<div class="col-6">
					<div class="messages">
						<c:if test="${not empty data.errorMessage}">
							<div class="alert alert-danger" role="alert">
								<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
								Error
								${data.errorMessage}
							</div>
						</c:if>
					</div>
					
					<h1 class="display-3"><fmt:message key="context.title" /></h1>
					
					<form id="upload_form" action="context" method="POST" enctype="multipart/form-data" class="form-horizontal">
						<h2><i class="fal fa-shapes"></i>&nbsp;&nbsp;<fmt:message key="context.shapes.title" /></h2>
						
						<blockquote class="blockquote bq-primary">
							
							<div class="form-group row">
								<label for="inputShapeFile" class="col-sm-3 col-form-label">
							    
							    	<input
											type="radio"
											name="shapesSource"
											id="shapesSource-inputShapeFile"
											value="file"
											checked="checked"
											onchange="enabledShapeInput('inputShapeFile')" />
							    	<fmt:message key="context.shapes.upload" />
							    
							    </label>
							    <div class="col-sm-9">
							    		<div class="fileinput fileinput-new input-group" data-provides="fileinput">
										  <div class="form-control" data-trigger="fileinput" id="inputShapeFile">
										    <i class="fal fa-upload"></i><span class="fileinput-filename with-icon"></span>
										  </div>
										  <span class="input-group-append">
										    <span class="input-group-text fileinput-exists" data-dismiss="fileinput">
										      <fmt:message key="context.shapes.upload.remove" />
										    </span>
										
										    <span class="input-group-text btn-file">
										      <span class="fileinput-new"><fmt:message key="context.shapes.upload.select" /></span>
										      <span class="fileinput-exists"><fmt:message key="context.shapes.upload.change" /></span>
										      <input type="file" name="inputShapeFile" multiple onchange="enabledShapeInput('inputShapeFile')">
										    </span>
										  </span>
										</div>
										<small class="form-text text-muted">
											  <fmt:message key="context.shapes.upload.help" />
									  </small>
							    </div>
							</div>
							
							<!--  URL -->
							<div class="form-group row">
								
							    <label for="inputShapeUrl" class="col-sm-3 col-form-label">
							    	<input
											type="radio"
											name="shapesSource"
											id="sourceShape-inputShapeUrl"
											value="url"
											onchange="enabledShapeInput('inputShapeUrl')" />
							    	<fmt:message key="context.shapes.url" />
							    </label>
							    <div class="col-sm-9">
							      <input 
							      	type="text"
							      	class="form-control"
							      	id="inputShapeUrl"
							      	name="inputShapeUrl"
							      	placeholder="<fmt:message key="context.shapes.url.placeholder" />"
							      	onkeypress="enabledShapeInput('inputShapeUrl');"
							      	onchange="enabledShapeInput('inputShapeUrl')"
							      >
							      <small class="form-text text-muted">
									  <fmt:message key="context.shapes.url.help" />
							    </small>
							    </div>
							  </div>
							   
						</blockquote>
						
						<h2><i class="fal fa-tools"></i>&nbsp;&nbsp;<fmt:message key="context.options.title" /></h2>
				      	<blockquote class="blockquote bq-warning">
					      
					      <div class="form-group row">
					      	<div class="col-sm-9">
								<label for="inputShapeCatalog" class="col-sm-3 col-form-label">
									<fmt:message key="context.options.format" />					    
								</label>
							    <div class="col-sm-4">
						    		<select class="form-control" id="format" name="format" >
						    			<option value="Turtle">Turtle</option>
						    			<option value="RDF/XML">RDF/XML</option>
						    			<option value="N-Triples">N-Triples</option>
						    			<option value="N-Quads">N-Quads</option>
						    			<option value="N3">N3</option>
						    			<option value="TriG">TriG</option>
						    			<option value="JSON-LD">Json-LD</option>
									</select>
								</div>
							</div>
						</div>
						  
						  	<!-- Option count ocurrences -->
						 <div class="form-group row"> 	
						  	<div class="form-group row">
						      	<div class="col-sm-12">
							      	<div class="form-check">
									  <input class="form-check-input col-sm-2" type="checkbox" id="Ocurrencesinstances" name="Ocurrencesinstances" onclick='chkbOIClick(this)' />
									  <label class="col-sm-12 form-check-label" for="Ocurrencesinstances">
									    <fmt:message key="context.options.Ocurrencesinstances" />
									  </label>
									  <small class="form-text text-muted">
										<fmt:message key="context.options.Ocurrencesinstances.help" />
									  </small>
									</div>
								</div>
							</div>						  
						  </div>						  
					  	</blockquote>
						
						<button type="submit" id="validate-button" class="btn btn-info btn-lg"><fmt:message key="generate.submit" /></button>
					</form>	
					
					<!-- Documentation -->	
					<div style="margin-top:3em;">
						<h3 id="documentation">Documentation</h3>
						
						<p>This algorithm <em>derives a set of SHACL constraints from an RDF dataset</em>. It can work from an uploaded RDF dataset, or from an online SPARQL endpoint.<p/>
						<p>This algorithm was derived from <a href="https://github.com/cognizone/asquare/tree/develop/cube/src/main/java/zone/cogni/asquare/cube/convertor/data2shacl">this original one</a> implemented by <a href="https://www.cogni.zone/">Cognizone</a> here. Credits to them. It was improved in significant ways:</p>
						<ul>
							<li>Used a layered visitor patterns architecture for more modularity</li>
							<li>Used sampling technique to work with large datasets</li>
							<li>Improved NodeShape derivation algorithm to exclude certain types, when entities have multiple types</li>
							<li>Added counting of entities and properties</li>
						</ul>
						<p>This can work best if the dataset:</p>
						<ul>
							<li>Uses one and only one rdf:type value per entity (although the algorithm can be smart enough to exclude some types, see below)</li>
							<li>Contains only data, not the RDFS/OWL model</li>
						</ul>
						
						
						<div style="margin-top:2em;">
							<h4 id="documentation">SHACL generation algorithm</h4>
							<p>The algorithm follow these steps to generate the SHACL:</p>
							
							<ol>
								<li>
									<strong>Find all types in the dataset</strong>.
									Relies on <a href="https://github.com/sparna-git/shacl-play/blob/master/shacl-generate/src/main/resources/shacl/generate/select-types.rq">this SPARQL query</a>.
									Generates one <code>sh:NodeShape</code> for each type, with <code>sh:targetClass</code> set to the type.</li>
								<li>
									For each found type, <strong>find all properties used on instances of this type</strong>.
									Relies on <a href="https://github.com/sparna-git/shacl-play/blob/master/shacl-generate/src/main/resources/shacl/generate/select-properties.rq">this SPARQL query</a>.
									Generates one <code>sh:PropertyShape</code> for each property on the type, with an <code>sh:path</code> set to this property.
								</li>
								<li>
									For each property shape previously found, <strong>determine its node kind (IRI or Literal)</strong>.
									Relies on <a href="https://github.com/sparna-git/shacl-play/blob/master/shacl-generate/src/main/resources/shacl/generate/nodekind-is-blank.rq">this SPARQL query</a>,
									<a href="https://github.com/sparna-git/shacl-play/blob/master/shacl-generate/src/main/resources/shacl/generate/nodekind-is-iri.rq">this one</a>,
									and <a href="https://github.com/sparna-git/shacl-play/blob/master/shacl-generate/src/main/resources/shacl/generate/nodekind-is-literal.rq">this one</a>.
									Generates the <code>sh:nodeKind</code> constraint on the property shape accordingly.
								</li>
								<li>
									For each property shape previously found with a sh:nodeKind IRI or BlankNode, <strong>determine the types of the property values</strong>.
									Relies on <a href="https://github.com/sparna-git/shacl-play/blob/master/shacl-generate/src/main/resources/shacl/generate/select-object-types.rq">this SPARQL query</a>.
									Generates the <code>sh:class</code> constraint on the property shape accordingly. If more than one class is found, the algorithm determines if some can be removed:
									<ul>
										<li>If one class is a superset of all other classes found, (indicating that the dataset uses some redundancy on the typing of instances, e.g. assigning skos:Concept
										and a subclass of skos:Concept to entities), but is a superset of other classes as well, then the this superset class (e.g. skos:Concept) is removed from the list, 
										and only the most precise class(-es) are kept.</li>
										<li>If one class is a superset of all other classes found, and is not a superset of other classes, then only the superset class is kept, and other more precise classes
										are removed from the list</li>
									</ul>
								</li>
								<li>
									For each property shape previously found with a sh:nodeKind Literal, <strong>determine the datatype and languages of the property values</strong>.
									Relies on <a href="https://github.com/sparna-git/shacl-play/blob/master/shacl-generate/src/main/resources/shacl/generate/select-datatypes.rq">this SPARQL query</a>,
									and <a href="https://github.com/sparna-git/shacl-play/blob/master/shacl-generate/src/main/resources/shacl/generate/select-languages.rq">this one</a>.
									Generates the <code>sh:datatype</code> and <code>sh:languageIn</code> constraints on the property shape accordingly.
								</li>
								<li>
									For each property shape previously found, <strong>determine the cardinalities of the property</strong>.
									Relies on <a href="https://github.com/sparna-git/shacl-play/blob/master/shacl-generate/src/main/resources/shacl/generate/has-instance-without-property.rq">this SPARQL query</a>,
									and <a href="https://github.com/sparna-git/shacl-play/blob/master/shacl-generate/src/main/resources/shacl/generate/has-instance-with-two-properties.rq">this one</a>.
									This can determine one minimum and maximum cardinalities set to 1.
									Generates the <code>sh:minCount</code> and <code>sh:maxCount</code> constraints on the property shape accordingly.
								</li>
								<li>
									For each property shape previously found, <strong>list the values of the property if it has a limited number of possible values</strong>.
									Relies on <a href="https://github.com/sparna-git/shacl-play/blob/master/shacl-generate/src/main/resources/shacl/generate/count-distinct-values.rq">this SPARQL query</a>.
									This is done only if the property has 3 distinct values or less.
									Generates an <code>sh:in</code> or <code>sh:hasValue</code> constraint on the property shape accordingly.
								</li>
								<li>
									For each node shape previously found, <strong>determines if one of the property shape is a label of the entity</strong>.
									If a property skos:prefLabel, foaf:name, dcterms:title, schema:name or rdfs:label (in this order) is found, mark it as a label. Otherwise, tries to find
									a literal property of datatype xsd:string or rdf:langString, with a sh:minCount 1; if only is found, mark it as a label.
									Generates a <code>dash:propertyRole</code> with <code>dash:LabelRole</code> value accordingly.
								</li>
								<li>
									If requested, for each node shape and property shape previously found, <strong>count the number of instances of node shapes, number of occurrences of property shapes, and number of distinct values.</strong>.
									This currently works only with sh:targetClass target definition, but can be easily extended to deal with other target definition.
									Generates a <code>void:Dataset</code>, <code>void:classPartition</code>, <code>void:propertyPartition</code> with a <code>dcterms:conformsTo</code> pointing to the corresponding shapes.
									Stores the counting in either <code>void:entities</code>, <code>void:triples</code>, or <code>void:distinctObjects</code> properties.
								</li>
							</ol>
							
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- /.container-fluid -->


		<jsp:include page="footer.jsp"></jsp:include>

		<!-- SCRIPTS -->
		<!-- JQuery -->
		<script type="text/javascript" src="<c:url value="/resources/MDB-Free/js/jquery.min.js" />"></script>
		<!-- Bootstrap tooltips -->
		<script type="text/javascript" src="<c:url value="/resources/MDB-Free/js/popper.min.js" />"></script>
		<!-- Bootstrap core JavaScript -->
		<script type="text/javascript" src="<c:url value="/resources/MDB-Free/js/bootstrap.min.js" />"></script>
		<!-- MDB core JavaScript -->
		<script type="text/javascript" src="<c:url value="/resources/MDB-Free/js/mdb.min.js" />"></script>
	
		<script type="text/javascript"src="<c:url value="/resources/jasny-bootstrap/jasny-bootstrap.min.js" />"></script>


		<script>
			$(document).ready(function() {
				$('#htmlOrRdf a').click(function(e) {
					e.preventDefault();
					$(this).tab('show')
				});
	
				// Initialize CodeMirror editor and the update callbacks
				var sourceText = document.getElementById('text');
				var editorOptions = {
					mode : 'text/html',
					tabMode : 'indent'
				};
	
				// CodeMirror commented for now
				// var editor = CodeMirror.fromTextArea(sourceText, editorOptions);
				// editor.on("change", function(cm, event) { enabledInput('text'); });
			});
		</script>

	</body>
</html>