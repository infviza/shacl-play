<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!-- setup the locale for the messages based on the language in the session -->
<fmt:setLocale value="${sessionScope['fr.sparna.rdf.shacl.shaclplay.SessionData'].userLocale.language}"/>
<fmt:setBundle basename="fr.sparna.rdf.shacl.shaclplay.i18n.shaclplay"/>

<c:set var="data" value="${requestScope['SparqlFormData']}" />

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
	
			function enabledInput(selected) {
				document.getElementById('source-' + selected).checked = true;
				document.getElementById('inputUrl').disabled = selected != 'inputUrl';
				document.getElementById('inputFile').disabled = selected != 'inputFile';
				document.getElementById('inputInline').disabled = selected != 'inputInline';
			}
			
			function enabledShapeInput(selected) {
				document.getElementById('sourceShape-' + selected).checked = true;
				document.getElementById('inputShapeUrl').disabled = selected != 'inputShapeUrl';
				document.getElementById('inputShapeFile').disabled = selected != 'inputShapeFile';
				document.getElementById('inputShapeInline').disabled = selected != 'inputShapeInline';
			}
			
			function dowloadExample(){
				var exampleText= $('#example option:selected').text();
			    $('#lien').attr('href', urlExample);
			    $('a#lien').text(exampleText);
			}	

	    </script>
		
		
	</head>
	<body>

	<jsp:include page="navbar.jsp">
		<jsp:param name="active" value="sparql"/>
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
				
				<h1 class="display-3"><c:choose><c:when test="${empty data.selectedShapesKey}"><fmt:message key="sparql.title" /></c:when><c:otherwise><fmt:message key="sparql.title.validateWith" /> ${data.catalog.getCatalogEntryById(data.selectedShapesKey).title}</c:otherwise></c:choose></h1>	
	 
			  	<form id="upload_form" action="sparql" method="POST" enctype="multipart/form-data" class="form-horizontal">
				      
				      <h2><i class="fal fa-shapes"></i>&nbsp;&nbsp;<fmt:message key="sparql.inputData.title" /></h2>
				      <blockquote class="blockquote bq-success">
				      <div class="form-group row">
				      	
					    <label for="inputFile" class="col-sm-3 col-form-label">
					    
					    	<input
									type="radio"
									name="source"
									id="source-inputFile"
									value="file"
									checked="checked"
									onchange="enabledInput('inputFile')" />
					    	<fmt:message key="sparql.inputData.upload" />
					    
					    </label>
					    <div class="col-sm-9">
					    		<div class="fileinput fileinput-new input-group" data-provides="fileinput">
								  <div class="form-control" data-trigger="fileinput" id="inputFile">
								    <i class="fal fa-upload"></i><span class="fileinput-filename with-icon"></span>
								  </div>
								  <span class="input-group-append">
								    <span class="input-group-text fileinput-exists" data-dismiss="fileinput">
								      <fmt:message key="sparql.inputData.upload.remove" />
								    </span>
								
								    <span class="input-group-text btn-file">
								      <span class="fileinput-new"><fmt:message key="sparql.inputData.upload.select" /></span>
								      <span class="fileinput-exists"><fmt:message key="sparql.inputData.upload.change" /></span>
								      <input type="file" name="inputFile" multiple onchange="enabledInput('inputFile')">
								    </span>
								  </span>
								</div>
								<small class="form-text text-muted">
								  <fmt:message key="sparql.inputData.upload.help" />
								</small>
					    </div>
					  </div>
					  <div class="form-group row">
					    <label for="inputUrl" class="col-sm-3 col-form-label">
					    
					    	<input
									type="radio"
									name="source"
									id="source-inputUrl"
									value="url"
									onchange="enabledInput('inputUrl')" />
					    	<fmt:message key="sparql.inputData.url" />
					    </label>
					    <div class="col-sm-9">
					      <input 
					      	type="text"
					      	class="form-control"
					      	id="inputUrl"
					      	name="inputUrl"
					      	placeholder="<fmt:message key="sparql.inputData.url.placeholder" />"
					      	onkeypress="enabledInput('inputUrl');"
					      	onpaste="enabledInput('inputUrl');"
					      />
					      <small class="form-text text-muted">
								  <fmt:message key="sparql.inputData.url.help" />
						  </small>
					    </div>
					  </div>
					  <div class="form-group row">
					    <label for="inputInline" class="col-sm-3 col-form-label">
					    
					    	<input
									type="radio"
									name="source"
									id="source-inputInline"
									value="inline"
									onchange="enabledInput('inputInline')" />
					    	<fmt:message key="sparql.inputData.inline" />
					    </label>
					    <div class="col-sm-9">
					      <textarea 
					      	class="form-control"
					      	id="inputInline"
					      	name="inputInline"
					      	rows="5"
					      	onkeypress="enabledInput('inputInline');"
							onpaste="enabledInput('inputInline')"
					      ></textarea>
					      <small class="form-text text-muted">
								  <fmt:message key="sparql.inputData.inline.help" />
						  </small>
					    </div>
					  </div>
					  </blockquote>
					  
					  <c:if test="${empty data.selectedShapesKey}">
						  <h2><i class="fal fa-shapes"></i>&nbsp;&nbsp;<fmt:message key="sparql.shapes.title" /></h2>
						  <blockquote class="blockquote bq-primary">		  
						  
						      <div class="form-group row">
		
							    <label for="inputShapeFile" class="col-sm-3 col-form-label">
							    
							    	<input
											type="radio"
											name="shapesSource"
											id="sourceShape-inputShapeFile"
											value="file"
											checked="checked"
											onchange="enabledShapeInput('inputShapeFile')" />
							    	<fmt:message key="sparql.shapes.upload" />
							    
							    </label>
							    <div class="col-sm-9">
							    		<div class="fileinput fileinput-new input-group" data-provides="fileinput">
										  <div class="form-control" data-trigger="fileinput" id="inputShapeFile">
										    <i class="fal fa-upload"></i><span class="fileinput-filename with-icon"></span>
										  </div>
										  <span class="input-group-append">
										    <span class="input-group-text fileinput-exists" data-dismiss="fileinput">
										      <fmt:message key="sparql.shapes.upload.remove" />
										    </span>
										
										    <span class="input-group-text btn-file">
										      <span class="fileinput-new"><fmt:message key="sparql.shapes.upload.select" /></span>
										      <span class="fileinput-exists"><fmt:message key="sparql.shapes.upload.change" /></span>
										      <input type="file" name="inputShapeFile" multiple onchange="enabledShapeInput('inputShapeFile')">
										    </span>
										  </span>
										</div>
										<small class="form-text text-muted">
											  <fmt:message key="sparql.shapes.upload.help" />
									  </small>
							    </div>
							  </div>
						      
						      <c:if test="${not empty data.catalog.entries}">
							      <div class="form-group row">	
								    <label for="inputShapeCatalog" class="col-sm-3 col-form-label">
								    
								    	<input
												type="radio"
												name="shapesSource"
												id="sourceShape-inputShapeCatalog"
												value="catalog"
												onchange="enabledShapeInput('inputShapeCatalog')" />
								    	<fmt:message key="sparql.shapes.catalog" />					    
								    </label>
								    <div class="col-sm-9">
								    		<select class="form-control" id="inputShapeCatalog" name="inputShapeCatalog" onchange="enabledShapeInput('inputShapeCatalog');">
										      	<c:forEach items="${data.catalog.entries}" var="entry">
										      		<option value="${entry.id}">${entry.title}</option>
										      	</c:forEach>
										    </select>
										    <small class="form-text text-muted">
												  <fmt:message key="sparql.shapes.catalog.help" />
										    </small>
								    </div>
								  </div>
							  </c:if>
							  
							  <div class="form-group row">
							    <label for="inputShapeUrl" class="col-sm-3 col-form-label">
							    
							    	<input
											type="radio"
											name="shapesSource"
											id="sourceShape-inputShapeUrl"
											value="url"
											onchange="enabledShapeInput('inputShapeUrl')" />
							    	<fmt:message key="sparql.shapes.url" />
							    </label>
							    <div class="col-sm-9">
							      <input 
							      	type="text"
							      	class="form-control"
							      	id="inputShapeUrl"
							      	name="inputShapeUrl"
							      	placeholder="<fmt:message key="sparql.shapes.url.placeholder" />"
							      	onkeypress="enabledShapeInput('inputShapeUrl');"
							      	onchange="enabledShapeInput('inputShapeUrl')"
							      >
							      <small class="form-text text-muted">
									  <fmt:message key="sparql.shapes.url.help" />
							    </small>
							    </div>
							  </div>
							  <div class="form-group row">
							    <label for="inputShapeInline" class="col-sm-3 col-form-label">
							    
							    	<input
											type="radio"
											name="shapesSource"
											id="sourceShape-inputShapeInline"
											value="inline"
											onchange="enabledShapeInput('inputShapeInline')" />
							    	<fmt:message key="sparql.shapes.inline" />
							    </label>
							    <div class="col-sm-9">
							      <textarea 
							      	class="form-control"
							      	id="inputShapeInline"
							      	name="inputShapeInline"
							      	rows="5"
							      	onkeypress="enabledShapeInput('inputShapeInline');"
							      	onpaste="enabledShapeInput('inputShapeInline');"
							      ></textarea>
							      <small class="form-text text-muted">
									  <fmt:message key="sparql.shapes.inline.help" />
								  </small>
							    </div>	
						      </div>
					      </blockquote>
					  </c:if>
					  <c:if test="${not empty data.selectedShapesKey}">
					  	<input type="hidden" name="shapesSource" value="catalog" />
					  	<input type="hidden" name="inputShapeCatalog" value="${data.selectedShapesKey}" />
					  </c:if>
					  
					  
					  
					  <h2><i class="fal fa-tools"></i>&nbsp;&nbsp;<fmt:message key="sparql.options.title" /></h2>
				      <blockquote class="blockquote bq-warning">					      
					      <div class="form-group row">
					      	<div class="col-sm-12">
						      	<div class="form-check">
								  <input class="form-check-input" type="checkbox" id="formatCombine" name="formatCombine" checked="checked" />
								  <label class="form-check-label" for="formatCombine">
								    <fmt:message key="sparql.options.formatCombine" />
								  </label>
								  <small class="form-text text-muted">
									<fmt:message key="sparql.options.formatCombine.help" />
								  </small>
								</div>
							</div>
						  </div>						  
					  </blockquote>
					  
				    <button type="submit" id="sparql-button" class="btn btn-info btn-lg"><fmt:message key="sparql.validate" /></button>			  	
			  	</form>
 		
			
				<!-- Documentation -->	
				<div style="margin-top:3em;">
					<h3>Documentation</h3>
					<div id="documentation">
						<h4>What is this tool ?</h4>
						<p>
						This is a SHACL-based SPARQL generator. It generates SPARQL queries used to extract a subset of data from a knowledge graph, 
						based on the SHACL specification of the target dataset structure.
						</p>
						<p>
						This tool takes into account a subset of SHACL constraints such as <code><a href="https://www.w3.org/TR/shacl/#HasValueConstraintComponent" target="_blank">sh:hasValue</a></code> , <code><a href="https://www.w3.org/TR/shacl/#InConstraintComponent" target="_blank">sh:in</a></code>, <code><a href="https://www.w3.org/TR/shacl/#LanguageInConstraintComponent" target="_blank">sh:languageIn</a></code>, <code><a href="https://www.w3.org/TR/shacl/#NodeConstraintComponent" target="_blank">sh:node</a></code> or <code><a href="https://www.w3.org/TR/shacl/#property-path-inverse" target="_blank">sh:inversePath</a></code>.
						</p>
						<p>
						If generates <code><a href="https://www.w3.org/TR/rdf-sparql-query/#construct" target="_blank">CONSTRUCT</a></code> queries to return an RDF graph as an output.
						</p>
						<h4>Sample file</h4>
						<p> 
						   To test, and to better understand how the SPARQL query generation works you can download this <a href="<c:url value="/resources/example/PersonCountry.ttl"/>">turtle example of an application profile specified in SHACL</a>
						   , or the corresponding <a href="<c:url value="/resources/example/PersonCountry.xlsx"/>">Excel file</a> This Excel file can be converted in SHACL using 
						   the <a href="https://skos-play.sparna.fr/play/convert" target="_blank">SKOS Play xls2rdf conversion tool</a>. All the details about the conversion rules 
						   are documented in the converter page. This documentation only explains the query generation algorithms.					   					
						</p>				
					</div>
					
					<div style="margin-top:2em;">
						<h4>SHACL file structure</h4>
						<p>
							The SPARQL query generation requires that there is at least one NodeShape with <a href="https://www.w3.org/TR/shacl-af/#SPARQLTarget">SPARQL-based target</a>, 
							that is having a <code>sh:target</code> that itself has a <code>sh:select</code> giving the SPARQL query that defines the target of this shape.
							The SPARQL query in the <code>sh:select</code> is the starting point and is inserted as a subquery.
						</p>
						<!-- img Shacl File -->
						<img src="<c:url value="/resources/img/shacl_sparql_nodeshape_select.png"/>" width="100%"/>
						<br/>
						<br/>
						<h5>Properties Shapes</h5>
							<p>
								On property shapes, the following SHACL predicates and constraints are considered :
							</p>
							<h6>sh:path <small>(required)</small></h6>
							<p>
								The property indicated in <a href="https://www.w3.org/TR/shacl/#property-shapes" target="_blank">sh:path</a> is inserted in the CONSTRUCT clause as well as in the WHERE clause of the generated SPARQL query.
								<br>The only supported property paths in sh:path for the SPARQL query generation are <a href="https://www.w3.org/TR/shacl/#property-path-inverse">inverse property paths</a>.					
							</p>
							<h6>Optional filtering criterias</h6>
							<p>
								Within the property shape, 3 possible conditions are considered.
							</p>
							<ul>
								<li><code><a href="https://www.w3.org/TR/shacl/#HasValueConstraintComponent" target="_blank">sh:hasValue</a></code> : Value nodes must be equal to the given RDF term.
								This generates a <code>VALUES ?x {...}</code> condition in the SPARQL query.</li>
								<li><code><a href="https://www.w3.org/TR/shacl/#InConstraintComponent" target="_blank">sh:in</a></code> : Value nodes must be a member of the provided list of values.
								This generates a <code>VALUES ?x {...}</code> condition in the SPARQL query.</li>
								<li><code><a href="https://www.w3.org/TR/shacl/#LanguageInConstraintComponent" target="_blank">sh:languageIn</a></code> : The language tags for each value node must be inside the given list of language tags.
								This generates a <code>FILTER (lang(?x) IN(...))</code> condition in the SPARQL query.</li>						
							</ul>
						
							<h6>sh:node <small>(optional)</small></h6>
							<p>
								When a sh:path property has a <a href="https://www.w3.org/TR/shacl/#NodeConstraintComponent" target="_blank">sh:node</a> constraint, the SPARQL query generation "follows" the sh:node to generate either another SPARQL query or another UNION clause (see below).
							</p>
							<p>
								Multiple "target" sh:node are supported through the use of an <code><a href="https://www.w3.org/TR/shacl/#OrConstraintComponent" target="_blank">sh:or</a></code> constraint :
								<br />
								<code>sh:or([sh:node ex:nodeShape1][sh:node ex:nodeShape2])</code>
								<br />
								For each NodeShape indicated in the sh:or, a new SPARQL query or another UNION clause will be generated (see below).
							</p>

							<h6>sh:inversePath <small>(optional)</small></h6>
							<p><a href="https://www.w3.org/TR/shacl/#property-path-inverse" target="_blank">sh:inversePath</a> used in sh:path contains a blank node that is the subject of exactly one triple.
								<br/>
							   Using this insert inverse property paths in the generated SPARQL query : <code>?x ^foaf:knows ?y</code>
							</p>
							<br/>
							<img src="<c:url value="/resources/img/shacl_sparql_properties.png"/>" width="100%"/>
							<br/>
							<br/>
					</div>
					
					<div>
						<h4>SPARQL query generation algorithm (multiple queries)</h4>
						
						<!-- Shacl code convert to SPARQL Query -->
						<ol>
							<li>Start by looking at each NodeShape having a <code>sh:target</code> with a <code>sh:select</code>...</li>
							<li>Generate one query for the "starting point" NodeShape. In this query, for each PropertyShape :</li>
							<li>If the property shape has a <code>sh:hasValue</code> or <code>sh:in</code>, a VALUES clause is inserted, if it has <code>sh:languageIn</code> a FILTER clause will be inserted.
								<br/>
								<br/> 
								Example:<br/>
								<img src="<c:url value="/resources/img/Query0.png"/>" width="100%"/>
								<br/>
								<br/>
							</li>
							<li>Then, for each NodeShape referred to in an <code>sh:node</code> (or <code>sh:or</code> containing multiple sh:node), follow to the target
							NodeShape and apply the same algorithm recursively. The recursion stops when it encounters a NodeShape that was already processed.
								<br/>
								<br/>
								<p>Example: the <code>ex:Country</code> property in the Person NodeShape, refers to the <code>ex:City</code> NodeShape, through the <code>ex:country</code> property.
								This generates this second query:
										<br/>
										<!-- SPARQL Query from City -->
										<img src="<c:url value="/resources/img/Query_sh_node.png"/>" width="100%"/>
								</p>
								
							</li>
						</ol>
						<br/>
						<br/>
						<h4>SPARQL query generation algorithm (single query)</h4>
						<p>Instead of generating multiple queries, one for each "path" in the SHACL specification, it is possible to produce one single SPARQL query for each
						"starting point" NodeShape having a sh:target with a sh:select. The query uses a serie of <code>UNION</code> clauses.
						In this case, no filtering using <code>sh:hasValue</code> , <code>sh:in</code> or <code>sh:languageIn</code> happens. The query simply takes into account
						the structure of the triples in the graph, but cannot filter on their value
						</p>
					</div>

				</div>
				
				
			</div>
		</div>
		<br>
		<br>
		
				
			
		</div>
    </div><!-- /.container-fluid -->

			
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
    <!-- Example -->
    <script type="text/javascript" src="<c:url value="/resources/MDB-Free/js/mdb.min.js" />"></script>
	
    <script type="text/javascript" src="<c:url value="/resources/jasny-bootstrap/jasny-bootstrap.min.js" />"></script>

	<!-- anchorjs -->
    <script src="https://cdn.jsdelivr.net/npm/anchor-js/anchor.min.js"></script>
    
    <script>
    	$(document).ready(function () {
	    	$('#htmlOrRdf a').click(function (e) {
	    	  e.preventDefault();
	    	  $(this).tab('show')
	    	});
	    	
	        // Initialize CodeMirror editor and the update callbacks
	        var sourceText = document.getElementById('text');
	        var editorOptions = {
	          mode: 'text/html',
	          tabMode: 'indent'
	        };
	        
	        // CodeMirror commented for now
	        // var editor = CodeMirror.fromTextArea(sourceText, editorOptions);
	        // editor.on("change", function(cm, event) { enabledInput('text'); });
    	});
    	
    	// activate example choice
  		$('.exampleEntry').click(function() {
  			$('#exampleLabel').html($(this).html());
  		});
    	
    </script>
    <!-- API Anchor -->
    <script>
		anchors.options = {
			  icon: '#'
			};
		anchors.options.placement = 'left';
		anchors.add();		
	</script>
    
  </body>
</html>