"
A FAMIX2JavaVisitorTest is a test class for testing the behavior of FAMIX2JavaVisitor
"
Class {
	#name : #FAMIX2JavaVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'visitor'
	],
	#category : #'Famix2Java-Tests'
}

{ #category : #test }
FAMIX2JavaVisitorTest >> setUp [ 
	super setUp.
	visitor := FAMIX2JavaVisitor new.
	visitor endOfLine: String cr
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testCompareFileStructureSimilarity [

	|exported original paths exportPath originPath|
	
	"give the absolute path of the exported folder and the original folder"
	exportPath := ''.
	originPath := ''.
	
	exported := exportPath
		            asFileReference allChildrenMatching: '*.java'.
	original := originPath
		            asFileReference allChildrenMatching: '*.java'.
		
	
	paths := Dictionary new. 
	
	exported := exported collect: [ :path | 
		              | relatif |
		              
		              relatif := path pathSegments
			                         copyFrom:
			                         (path pathSegments indexOf:
				                          'legacy-ecompta')
			                         to: path pathSegments size.
						relatif := ('/' join: relatif) asFileReference .
						
"						self haltIf: [ path asString = 'File @ /Users/nicolashlad/Development/_temp/legacy-ecompta/client/src/main/java/fr/magnus/achats/transverse/FA_LI.java' ].
						"
						paths at: (relatif asFileReference) ifAbsentPut: [ Dictionary new add: ('EXP' -> relatif) ; yourself].
		                 ].
	
	original := original collect: [ :path | 
		              | relatif |

						
		              relatif := path pathSegments
			                         copyFrom:
			                         (path pathSegments indexOf:
				                          'legacy-ecompta')
			                         to: path pathSegments size.
						relatif := ('/' join: relatif) asFileReference .
						
						
		             paths at: (relatif asFileReference) ifPresent: [ :v |  v add: ('ORG' -> path) ] ifAbsentPut: [ Dictionary new add: ('ORG' -> relatif) ; yourself].
						 ].

	"paths	inspect."
	
	"possible test failure if original files have i) fully commented java file or ii) missing package-info.java in exported folder, sine they do not contain java code"
	self assert: (paths associations select: [ :assoc | assoc value size = 1]) size equals: 0.

]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitAttribute [

	| attribute attributeClass attributeDeclaredType sourceAnchor model resultString |
	model := FamixJavaModel new.
	attributeDeclaredType := FamixJavaClass new.
	attributeDeclaredType name: 'AttributeClass'.
	attribute := FamixJavaAttribute new.
	attribute name: 'anAttribute'.
	attribute declaredType: attributeDeclaredType. 
	sourceAnchor := FamixJavaSourceTextAnchor new.
	sourceAnchor source: ''.
	attribute sourceAnchor: sourceAnchor.
	attributeClass := FamixJavaClass new.
	attributeClass addAttribute: attribute.
	model addAll: { 
			attribute.
			attributeClass.
			sourceAnchor }.
	resultString := String streamContents: [ :stream | 
		                visitor currentStream: stream.
		                attribute accept: visitor ].
	self assert: resultString equals: 'AttributeClass anAttribute;'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitMethodWithDeclaredException [

	| method methodClass exception model resultString |
	model := FamixJavaModel new.
	exception := FamixJavaException new
		             name: 'MyException';
		             yourself.
	method := FamixJavaMethod new.
	method name: 'aMethod'.
	method addDeclaredException: exception.

	methodClass := FamixJavaClass new.
	methodClass addMethod: method.
	model addAll: { 
			exception.
			method.
			methodClass }.
	resultString := String streamContents: [ :stream | 
		                visitor currentStream: stream.
		                method accept: visitor ].
	self assert: resultString equals: 'aMethod() throws MyException {

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitMethodWithThrownException [

	| method methodClass exception model resultString |
	model := FamixJavaModel new.
	exception := FamixJavaException new
		             name: 'MyException';
		             yourself.
	method := FamixJavaMethod new.
	method name: 'aMethod'.
	method addThrownException: exception.

	methodClass := FamixJavaClass new.
	methodClass addMethod: method.
	model addAll: { 
			exception.
			method.
			methodClass }.
	resultString := String streamContents: [ :stream | 
		                visitor currentStream: stream.
		                method accept: visitor ].
	self assert: resultString equals: 'aMethod() throws MyException {

}'
]
