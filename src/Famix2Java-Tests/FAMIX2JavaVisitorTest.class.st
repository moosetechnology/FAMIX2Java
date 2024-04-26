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
FAMIX2JavaVisitorTest >> testDoNotExportPackageStub [

	| model aClass orgPackage memory comStubPackage aStubClass |
	model := FamixJavaModel new.
	orgPackage := FamixJavaPackage new.
	orgPackage name: 'org'.
	aClass := FamixJavaClass new
		          name: 'DemoClass';
		          yourself.
	orgPackage addType: aClass.


	comStubPackage := FamixJavaPackage new.
	comStubPackage name: 'com'.
	aStubClass := FamixJavaClass new
		              name: 'DemoStubClass';
		              yourself.
	comStubPackage addType: aStubClass.
	comStubPackage isStub: true.
	aStubClass isStub: true.

	model addAll: {
			aClass.
			orgPackage.
			comStubPackage.
			aStubClass }.
	"Export the model"
	memory := FileSystem memory.
	FAMIX2JavaVisitor new
		rootFolder: (memory / 'exported') asFileReference;
		export: model.
	self assert: (memory / 'exported') asFileReference exists.
	self assert: (memory / 'exported' / 'org') asFileReference exists.
	self deny: (memory / 'exported' / 'com') asFileReference exists.
	self assert:
		(memory / 'exported' / 'org') asFileReference isDirectory.
	self assert:
		(memory / 'exported' / 'org' / 'DemoClass.java') asFileReference
			exists.
	self assert:
		(memory / 'exported' / 'org' / 'DemoClass.java') asFileReference
			isFile
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testExportPackage [

	| model aClass orgPackage memory |
	model := FamixJavaModel new.
	orgPackage := FamixJavaPackage new.
	orgPackage name: 'org'.
	aClass := FamixJavaClass new
		          name: 'DemoClass';
		          yourself.
	orgPackage addType: aClass.

	model addAll: {
			aClass.
			orgPackage }.
	"Export the model"
	memory := FileSystem memory.
	FAMIX2JavaVisitor new
		rootFolder: (memory / 'exported') asFileReference;
		export: model.
	self assert: (memory / 'exported') asFileReference exists.
	self assert: (memory / 'exported' / 'org') asFileReference exists.
	self assert:
		(memory / 'exported' / 'org') asFileReference isDirectory.
	self assert:
		(memory / 'exported' / 'org' / 'DemoClass.java') asFileReference
			exists.
	self assert:
		(memory / 'exported' / 'org' / 'DemoClass.java') asFileReference
			isFile
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testImportAttributeDeclaredTypeIfPossible [

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
FAMIX2JavaVisitorTest >> testVisitBasicClass [

	| model resultString aClass |
	model := FamixJavaModel new.
	aClass := FamixJavaClass new
		          name: 'DemoClass';
		          yourself.

	model addAll: { aClass }.
	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self assert: resultString equals: 'public class DemoClass {


}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitBasicClassThatHasOneInterface [

	| model resultString aClass implementation anInterface |
	model := FamixJavaModel new.
	aClass := FamixJavaClass new
		          name: 'DemoClass';
		          yourself.
	anInterface := FamixJavaInterface new
		               name: 'DemoOneInterface';
		               yourself.

	implementation := FamixJavaImplementation new
		               implementingClass: aClass;
		               interface: anInterface;
		               yourself.
	model addAll: {
			aClass.
			anInterface.
			implementation }.
	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self
		assert: resultString
		equals: 'public class DemoClass implements DemoOneInterface {


}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitBasicClassThatHasSuperClass [

	| model resultString aClass inheritance aSuperClass |
	model := FamixJavaModel new.
	aClass := FamixJavaClass new
		          name: 'DemoClass';
		          yourself.
	aSuperClass := FamixJavaClass new
		               name: 'DemoSuperClass';
		               yourself.

	inheritance := FamixJavaInheritance new
		               subclass: aClass;
		               superclass: aSuperClass;
		               yourself.
	model addAll: {
			aClass.
			aSuperClass.
			inheritance }.
	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self
		assert: resultString
		equals: 'public class DemoClass extends DemoSuperClass {


}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitBasicClassThatHasTwoInterfaces [

	| model resultString aClass implementation anInterface anInterface2 implementation2 |
	model := FamixJavaModel new.
	aClass := FamixJavaClass new
		          name: 'DemoClass';
		          yourself.
	anInterface := FamixJavaInterface new
		               name: 'DemoOneInterface';
		               yourself.
	anInterface2 := FamixJavaInterface new
		                name: 'DemoTwoInterface';
		                yourself.


	implementation := FamixJavaImplementation new
		                  implementingClass: aClass;
		                  interface: anInterface;
		                  yourself.
	implementation2 := FamixJavaImplementation new
		                   implementingClass: aClass;
		                   interface: anInterface2;
		                   yourself.
	model addAll: {
			aClass.
			anInterface.
			anInterface2.
			implementation.
			implementation2 }.
	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self
		assert: resultString
		equals:
			'public class DemoClass implements DemoOneInterface, DemoTwoInterface {


}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitBasicInterface [

	| model resultString aClass |
	model := FamixJavaModel new.
	aClass := FamixJavaInterface new
		          name: 'DemoInterface';
		          yourself.

	model addAll: { aClass }.
	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self assert: resultString equals: 'public interface DemoInterface {


}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitClassWithDependencyAttribute [

	| attribute attributeClass attributeDeclaredType packageFr sourceAnchor model resultString |
	model := FamixJavaModel new.
	packageFr := FamixJavaPackage new.
	packageFr name: 'fr'.
	attributeDeclaredType := FamixJavaClass new.
	attributeDeclaredType name: 'AttributeClass'.
	packageFr addType: attributeDeclaredType.
	attribute := FamixJavaAttribute new.
	attribute name: 'anAttribute'.
	attribute declaredType: attributeDeclaredType.
	sourceAnchor := FamixJavaSourceTextAnchor new.
	sourceAnchor source: ''.
	attribute sourceAnchor: sourceAnchor.
	attributeClass := FamixJavaClass new.
	attributeClass name: 'OwnerClass'.
	attributeClass addAttribute: attribute.
	model addAll: {
			attribute.
			attributeClass.
			sourceAnchor.
			packageFr }.
	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                visitor printImports: attributeClass ].
	self assert: resultString equals: 'import fr.AttributeClass;
'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitClassWithDependencyAttributeAlsoStub [

	| attributeClass attributeDeclaredType model resultString packageFr packageOrg attribute sourceAnchor |
	"Create a dummy model"
	model := FamixJavaModel new.
	packageFr := FamixJavaPackage new.
	packageFr name: 'fr'.
	packageOrg := FamixJavaPackage new.
	packageOrg name: 'org'.
	attributeDeclaredType := FamixJavaClass new.
	attributeDeclaredType isStub: true.
	attributeDeclaredType name: 'AttributeClass'.
	packageOrg addType: attributeDeclaredType.
	packageOrg isStub: true.
	attribute := FamixJavaAttribute new.
	attribute name: 'anAttribute'.
	attribute declaredType: attributeDeclaredType.
	sourceAnchor := FamixJavaSourceTextAnchor new.
	sourceAnchor source: ''.
	attribute sourceAnchor: sourceAnchor.
	attributeClass := FamixJavaClass new.
	attributeClass name: 'OwnerClass'.
	attributeClass addAttribute: attribute.
	packageFr addType: attributeClass.
	model addAll: {
			attribute.
			attributeClass.
			sourceAnchor.
			packageFr.
			packageOrg }.


	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                visitor printImports: attributeClass ].
	self assert: resultString equals: 'import org.AttributeClass;
'
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

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitPrivateMethod [

	| method methodClass model resultString |
	model := FamixJavaModel new.
	method := FamixJavaMethod new.
	method isPrivate: true.
	method name: 'aMethod'.


	methodClass := FamixJavaClass new.
	methodClass addMethod: method.
	model addAll: { 
			method.
			methodClass }.
	resultString := String streamContents: [ :stream | 
		                visitor currentStream: stream.
		                method accept: visitor ].
	self assert: resultString equals: 'private aMethod() {

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitPublicMethod [

	| method methodClass model resultString |
	model := FamixJavaModel new.
	method := FamixJavaMethod new.
	method isPublic: true.
	method name: 'aMethod'.


	methodClass := FamixJavaClass new.
	methodClass addMethod: method.
	model addAll: { 
			method.
			methodClass }.
	resultString := String streamContents: [ :stream | 
		                visitor currentStream: stream.
		                method accept: visitor ].
	self assert: resultString equals: 'public aMethod() {

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitStaticMethod [

	| method methodClass model resultString |
	model := FamixJavaModel new.
	method := FamixJavaMethod new.
	method isClassSide: true.
	method name: 'aMethod'.


	methodClass := FamixJavaClass new.
	methodClass addMethod: method.
	model addAll: { 
			method.
			methodClass }.
	resultString := String streamContents: [ :stream | 
		                visitor currentStream: stream.
		                method accept: visitor ].
	self assert: resultString equals: 'static aMethod() {

}'
]
