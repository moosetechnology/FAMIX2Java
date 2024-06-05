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

{ #category : #running }
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
FAMIX2JavaVisitorTest >> testExportAnnotationImport [

	| model resultString aClass annotationType anAnnotationInstance package |
	model := FamixJavaModel new.
	aClass := model newClassNamed: 'DemoClass'.
	annotationType := model newAnnotationType.
	annotationType name: 'AnAnnotation'.
	anAnnotationInstance := model newAnnotationInstance.
	anAnnotationInstance annotationType: annotationType.
	aClass addAnnotationInstance: anAnnotationInstance.
	package := model newPackageNamed: 'fr'.
	annotationType typeContainer: package.


	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                visitor printImports: aClass ].
	self assert: resultString equals: 'import fr.AnAnnotation;
'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testExportInnerParametricClass [

	| model resultString aClass k orgPackage innerParametricClass |
	model := FamixJavaModel new.
	orgPackage := model newPackageNamed: 'org'.
	aClass := model newClassNamed: 'DemoClass'.
	orgPackage addType: aClass.

	innerParametricClass := FamixJavaParametricClass new.
	innerParametricClass name: 'DemoClass'.
	model add: innerParametricClass.
	aClass addType: innerParametricClass.

	k := FamixJavaParameterType named: 'K'.
	model add: k.
	innerParametricClass genericParameters: { k }.

	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self assert: resultString equals: 'package org;


public class DemoClass {

    public class DemoClass<K> {

    }

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testExportMultiLevelPackagesMultiHierarachyWithClassAtMultipleLevel [

	| model orgClass aCompanyClass orgPackage companyPackage memory frPackage otherCompanyPackage frClass otherCompanyClass |
	model := FamixJavaModel new.
	frPackage := model newPackageNamed: 'fr'.
	otherCompanyPackage := model newPackageNamed: 'otherCompany'.
	frClass := model newClassNamed: 'FrClass'.
	otherCompanyClass := model newClassNamed: 'OtherCompanyClass'.
	frPackage addType: frClass.
	frPackage addChildEntity: otherCompanyPackage.
	otherCompanyPackage addType: otherCompanyClass.

	orgPackage := model newPackageNamed: 'org'.
	companyPackage := model newPackageNamed: 'company'.
	orgClass := model newClassNamed: 'OrgClass'.
	aCompanyClass := model newClassNamed: 'CompanyClass'.
	orgPackage addType: orgClass.
	orgPackage addChildEntity: companyPackage.
	companyPackage addType: aCompanyClass.
	"Export the model"
	memory := FileSystem memory.
	FAMIX2JavaVisitor new
		rootFolder: (memory / 'exported') asFileReference;
		export: model.
	self assert: (memory / 'exported') asFileReference exists.
	self assert: (memory / 'exported' / 'org') asFileReference exists.
	self assert:
		(memory / 'exported' / 'org') asFileReference isDirectory.
	self
		assert: (memory / 'exported' / 'org') asFileReference children size
		equals: 2.
	self assert:
		(memory / 'exported' / 'org' / 'OrgClass.java') asFileReference
			exists.
	self assert:
		(memory / 'exported' / 'org' / 'OrgClass.java') asFileReference
			isFile.
	self assert:
		(memory / 'exported' / 'org' / 'company') asFileReference exists.
	self assert:
		(memory / 'exported' / 'org' / 'company') asFileReference
			isDirectory.
	self assert:
		(memory / 'exported' / 'org' / 'company' / 'CompanyClass.java')
			asFileReference exists.
	self assert:
		(memory / 'exported' / 'org' / 'company' / 'CompanyClass.java')
			asFileReference isFile.
	self assert: (memory / 'exported' / 'fr') asFileReference isDirectory.
	self
		assert: (memory / 'exported' / 'fr') asFileReference children size
		equals: 2.
	self assert:
		(memory / 'exported' / 'fr' / 'FrClass.java') asFileReference isFile.

	self assert:
		(memory / 'exported' / 'fr' / 'otherCompany') asFileReference
			isDirectory.

	self assert: (memory / 'exported' / 'fr' / 'otherCompany'
		 / 'OtherCompanyClass.java') asFileReference isFile
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testExportMultiLevelPackagesWithClassAtMultipleLevel [

	| model orgClass aCompanyClass orgPackage companyPackage memory |
	model := FamixJavaModel new.
	orgPackage := model newPackageNamed: 'org'.
	companyPackage := model newPackageNamed: 'company'.
	orgClass := model newClassNamed: 'OrgClass'.
	aCompanyClass := model newClassNamed: 'CompanyClass'.
	orgPackage addType: orgClass.
	orgPackage addChildEntity: companyPackage.
	companyPackage addType: aCompanyClass.
	"Export the model"
	memory := FileSystem memory.
	FAMIX2JavaVisitor new
		rootFolder: (memory / 'exported') asFileReference;
		export: model.
	self assert: (memory / 'exported') asFileReference exists.
	self assert: (memory / 'exported' / 'org') asFileReference exists.
	self assert:
		(memory / 'exported' / 'org') asFileReference isDirectory.
	self
		assert: (memory / 'exported' / 'org') asFileReference children size
		equals: 2.
	self assert:
		(memory / 'exported' / 'org' / 'OrgClass.java') asFileReference
			exists.
	self assert:
		(memory / 'exported' / 'org' / 'OrgClass.java') asFileReference
			isFile.
	self assert:
		(memory / 'exported' / 'org' / 'company') asFileReference exists.
	self assert:
		(memory / 'exported' / 'org' / 'company') asFileReference
			isDirectory.
	self assert:
		(memory / 'exported' / 'org' / 'company' / 'CompanyClass.java')
			asFileReference exists.
	self assert:
		(memory / 'exported' / 'org' / 'company' / 'CompanyClass.java')
			asFileReference isFile
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testExportOneClassInAnotherClass [

	| model aClass orgPackage innerClass resultString |
	model := FamixJavaModel new.
	orgPackage := model newPackageNamed: 'org'.
	aClass := model newClassNamed: 'DemoClass'.
	innerClass := model newClassNamed: 'InnerClass'.
	orgPackage addType: aClass.
	aClass addType: innerClass.

	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self assert: resultString equals: 'package org;


public class DemoClass {

    public class InnerClass {

    }

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testExportOnePackageWithMultipleClasses [

	| model aClass orgPackage memory aClass2 |
	model := FamixJavaModel new.
	orgPackage := FamixJavaPackage new.
	orgPackage name: 'org'.
	aClass := FamixJavaClass new
		          name: 'DemoClass';
		          yourself.
	aClass2 := model newClassNamed: 'DemoClass2'.
	orgPackage addType: aClass.
	orgPackage addType: aClass2.

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
		(memory / 'exported' / 'org' / 'DemoClass2.java') asFileReference
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
FAMIX2JavaVisitorTest >> testImportParametricClass [

	| method model resultString listConcrete methodClass javaPackage utilPackage listGeneric e obj listConcretisation listParameterConcretisation beanPackage |
	model := FamixJavaModel new.
	"Java Environnement"
	javaPackage := model newPackageNamed: 'java'.
	javaPackage isStub: true.
	utilPackage := model newPackageNamed: 'util'.
	utilPackage isStub: true.
	listGeneric := model newParametricInterface.
	listGeneric name: 'List'.
	e := model newParameterTypeNamed: 'E'.
	listGeneric addGenericParameter: e.
	utilPackage addType: listGeneric.

	"My environnement"
	beanPackage := model newPackageNamed: 'bean'.
	beanPackage isStub: true.
	methodClass := model newClassNamed: 'MyClass'.
	method := model newParametricMethod.
	method name: 'testMethod'.
	methodClass addMethod: method.
	"declaredType of testMethod List<Object>"
	listConcrete := model newParametricInterface.
	listConcrete name: 'List'.
	obj := model newTypeNamed: 'User'.
	beanPackage addType: obj.
	obj isStub: true.
	listConcrete addConcreteParameter: obj.

	"Link listConcrete to listGeneric"
	listConcretisation := model newConcretization.
	listConcretisation
		concreteEntity: listConcrete;
		genericEntity: listGeneric.

	listParameterConcretisation := model newParameterConcretization.
	listParameterConcretisation
		concreteParameter: obj;
		genericParameter: e.

	method declaredType: listConcrete.

	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                visitor printImports: methodClass ].
	self assert: resultString equals: 'import java.util.List;
import bean.User;
'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitAnnotationWithAttribute [

	| model resultString annotationType anAnnotationInstance annotationTypeAttribute annotationInstanceAttribute |
	model := FamixJavaModel new.
	annotationType := model newAnnotationType.	
	annotationType name: 'AnAnnotation'.
	anAnnotationInstance := model newAnnotationInstance.
	anAnnotationInstance annotationType: annotationType.
	
	annotationTypeAttribute := model newAnnotationTypeAttribute.
	annotationTypeAttribute name: 'annotationAttributeName'.
	
	
	annotationInstanceAttribute := FamixJavaAnnotationInstanceAttribute new.
	annotationInstanceAttribute value: 'true'.
	annotationInstanceAttribute annotationTypeAttribute: annotationTypeAttribute.
	anAnnotationInstance addAttribute: annotationInstanceAttribute.
	
	model add: annotationInstanceAttribute.
	


	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                anAnnotationInstance accept: visitor ].
	self assert: resultString equals: '@AnAnnotation(annotationAttributeName = true)'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitAnnotationWithoutAttribute [

	| model resultString annotationType anAnnotationInstance |
	model := FamixJavaModel new.
	annotationType := model newAnnotationType.
	annotationType name: 'AnAnnotation'. 
	anAnnotationInstance := model newAnnotationInstance.
	anAnnotationInstance annotationType: annotationType.


	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                anAnnotationInstance accept: visitor ].
	self assert: resultString equals: '@AnAnnotation'
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
FAMIX2JavaVisitorTest >> testVisitBasicClassWithAnnotation [

	| model resultString aClass annotationType anAnnotationInstance |
	model := FamixJavaModel new.
	aClass := model newClassNamed: 'DemoClass'.
	annotationType := model newAnnotationType.
	annotationType name: 'AnAnnotation'. 
	anAnnotationInstance := model newAnnotationInstance.
	anAnnotationInstance annotationType: annotationType.
	
	aClass addAnnotationInstance: anAnnotationInstance.

	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self assert: resultString equals: '@AnAnnotation
public class DemoClass {

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
FAMIX2JavaVisitorTest >> testVisitClassWithMethodsAndAttributes [

	| model resultString aClass primitiveVoid method method2 attributeDeclaredType attribute |
	model := FamixJavaModel new.
	aClass := model newClassNamed: 'DemoClass'.

	attributeDeclaredType := model newClassNamed: 'AttributeClass'.
	attribute := model newAttributeNamed: 'anAttribute'.
	attribute declaredType: attributeDeclaredType.
	aClass addAttribute: attribute.

	primitiveVoid := model newPrimitiveTypeNamed: 'void'.
	method := model newMethodNamed: 'aMethod'.

	method declaredType: primitiveVoid.
	aClass addMethod: method.

	method2 := model newMethodNamed: 'aMethodTwo'.
	method2 declaredType: primitiveVoid.
	aClass addMethod: method2.


	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self assert: resultString equals: 'public class DemoClass {

    AttributeClass anAttribute;

    void aMethod() {

    }

    void aMethodTwo() {

    }

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitInterfaceWithOneMethod [

	| model resultString anInterface voidPrimitive interfaceMethod |
	model := FamixJavaModel new.
	voidPrimitive := model newPrimitiveTypeNamed: 'void'.
	anInterface := model newInterface
		          name: 'DemoInterface';
		          yourself.

	"Add a method to the class"
	interfaceMethod := model newMethodNamed: 'insert'.
	interfaceMethod isPublic: true.
	interfaceMethod declaredType: voidPrimitive.
	
	anInterface addMethod: interfaceMethod.

	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                anInterface accept: visitor ].
	self assert: resultString equals: 'public interface DemoInterface {

    public void insert();

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitMethodDeclaredTypePrimitiveVoid [

	| method methodClass primitiveVoid model resultString |
	model := FamixJavaModel new.

	method := model newMethodNamed: 'aMethod'.
	primitiveVoid := model newPrimitiveTypeNamed: 'void'.
	method declaredType: primitiveVoid.

	methodClass := model newClass.
	methodClass addMethod: method.

	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                method accept: visitor ].
	self assert: resultString equals: 'void aMethod() {

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitMethodWithAnnotation [

	| method methodClass model resultString annotationType anAnnotationInstance |
	model := FamixJavaModel new.
	
	annotationType := model newAnnotationType.
	annotationType name: 'override'. 
	anAnnotationInstance := model newAnnotationInstance.
	anAnnotationInstance annotationType: annotationType.

	method := FamixJavaMethod new.
	method name: 'aMethod'.
	method addAnnotationInstance: anAnnotationInstance.


	methodClass := FamixJavaClass new.
	methodClass addMethod: method.
	model addAll: { 
			method.
			methodClass }.
	resultString := String streamContents: [ :stream | 
		                visitor currentStream: stream.
		                method accept: visitor ].
	self assert: resultString equals: '@override
aMethod() {

}'
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
FAMIX2JavaVisitorTest >> testVisitMethodWithParameter [

	| method methodClass parameter model resultString parameterClass |
	model := FamixJavaModel new.

	method := model newMethodNamed: 'aMethod'.
	parameterClass := model newClassNamed: 'AClass'.
	parameter := model newParameterNamed: 'aParameter'.

	parameter declaredType: parameterClass.
	method addParameter: parameter.

	methodClass := model newClass.
	methodClass addMethod: method.

	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                method accept: visitor ].
	self assert: resultString equals: 'aMethod(AClass aParameter) {

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitMethodWithParametricDeclaredType [

	| method model resultString parameter list methodClass |
	model := FamixJavaModel new.
	method := FamixJavaParametricMethod named: 'testMethod'.
	parameter := FamixJavaParameter named: 'list'.
	list := FamixJavaParametricClass named: 'List'.
	list addConcreteParameter: (FamixJavaType named: 'Object').
	parameter declaredType: list.
	method addParameter: parameter.
	method declaredType: list.
	method addConcreteParameter: list.
	methodClass := FamixJavaClass new.
	methodClass addMethod: method.
	model addAll: {
			parameter.
			list.
			method.
			methodClass }.
	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                method accept: visitor ].
	self
		assert: resultString
		equals: 'List<Object> testMethod(List<Object> list) {

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
FAMIX2JavaVisitorTest >> testVisitParametricClass [

	| model resultString aClass k |
	model := FamixJavaModel new.
	aClass := FamixJavaParametricClass new.
	aClass name: 'DemoClass'.
	model add: aClass.
	
	k := FamixJavaParameterType named: 'K'.
	model add: k.
	aClass genericParameters: { k }.

	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self assert: resultString equals: 'public class DemoClass<K> {

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitParametricClassWithMultipleParameters [

	| model resultString aClass k v z |
	model := FamixJavaModel new.
	aClass := FamixJavaParametricClass new.
	aClass name: 'DemoClass'.
	model add: aClass.

	k := FamixJavaParameterType named: 'K'.
	model add: k.
	v := FamixJavaParameterType named: 'V'.
	model add: v.
	z := FamixJavaParameterType named: 'Z'.
	model add: z.
	aClass genericParameters: {
			k.
			v.
			z }.

	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self assert: resultString equals: 'public class DemoClass<K, V, Z> {

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitParametricClassWithTwoParameters [

	| model resultString aClass k v |
	model := FamixJavaModel new.
	aClass := FamixJavaParametricClass new.
	aClass name: 'DemoClass'.
	model add: aClass.

	k := FamixJavaParameterType named: 'K'.
	model add: k.
	v := FamixJavaParameterType named: 'V'.
	model add: v.
	aClass genericParameters: {
			k.
			v }.

	resultString := String streamContents: [ :stream |
		                visitor currentStream: stream.
		                aClass accept: visitor ].
	self assert: resultString equals: 'public class DemoClass<K, V> {

}'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitPrivateAttribute [

	| attribute attributeClass attributeDeclaredType sourceAnchor model resultString |
	model := FamixJavaModel new.
	attributeDeclaredType := FamixJavaClass new.
	attributeDeclaredType name: 'AttributeClass'.
	attribute := FamixJavaAttribute new.
	attribute name: 'anAttribute'.
	attribute isPrivate: true.
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
	self assert: resultString equals: 'private AttributeClass anAttribute;'
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
FAMIX2JavaVisitorTest >> testVisitPrivateStaticFinalAttribute [

	| attribute attributeClass attributeDeclaredType sourceAnchor model resultString |
	model := FamixJavaModel new.
	attributeDeclaredType := FamixJavaClass new.
	attributeDeclaredType name: 'AttributeClass'.
	attribute := FamixJavaAttribute new.
	attribute name: 'anAttribute'.
	attribute isPrivate: true.
	attribute isClassSide: true.
	attribute isFinal: true.
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
	self
		assert: resultString
		equals: 'private static final AttributeClass anAttribute;'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitPrivateTransientAttribute [

	| attribute attributeClass attributeDeclaredType sourceAnchor model resultString |
	model := FamixJavaModel new.
	attributeDeclaredType := FamixJavaClass new.
	attributeDeclaredType name: 'AttributeClass'.
	attribute := FamixJavaAttribute new.
	attribute name: 'anAttribute'.
	attribute isPrivate: true.
	attribute isTransient: true.
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
	self assert: resultString equals: 'private transient AttributeClass anAttribute;'
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
