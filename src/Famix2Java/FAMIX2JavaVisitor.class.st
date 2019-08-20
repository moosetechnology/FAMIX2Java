"
model := (MooseModel importFromMSEStream: ('D:\path\to\mseFile.mse' asFileReference readStream)).
model rootFolder: 'D:\pathy\to\rootFolder'.

FAMIX2JavaVisitor new
	rootFolder: 'D:\Developpement\exported' asFileReference;
	export: model.
"
Class {
	#name : #FAMIX2JavaVisitor,
	#superclass : #FAMIXVisitor,
	#instVars : [
		'currentStream',
		'rootFolder',
		'tabs',
		'tabulationSize'
	],
	#category : #Famix2Java
}

{ #category : #'private-exporting' }
FAMIX2JavaVisitor >> << aString [
	"not opti at all"
	tabs * tabulationSize timesRepeat: [ currentStream << String space ].
	currentStream << aString
]

{ #category : #'private-exporting' }
FAMIX2JavaVisitor >> <<< aString [
	"without tab"
	currentStream << aString
]

{ #category : #'private-exporting' }
FAMIX2JavaVisitor >> crlf [
	currentStream << String crlf
]

{ #category : #'public-exporting' }
FAMIX2JavaVisitor >> export: aFAMIXCompatibilityModel [
	aFAMIXCompatibilityModel allModelNamespaces do: [ :namespace | self clone visit: namespace ]
]

{ #category : #accessing }
FAMIX2JavaVisitor >> initialize [
	tabs := 0.
	tabulationSize := 4
]

{ #category : #accessing }
FAMIX2JavaVisitor >> rootFolder [
	^ rootFolder
]

{ #category : #accessing }
FAMIX2JavaVisitor >> rootFolder: anObject [
	rootFolder := anObject
]

{ #category : #'private-exporting' }
FAMIX2JavaVisitor >> space [
	currentStream << String space
]

{ #category : #accessing }
FAMIX2JavaVisitor >> visit: anEntity [
	super visit: anEntity
]

{ #category : #accessing }
FAMIX2JavaVisitor >> visitAttribute: aAttribute [
	aAttribute declaredType ifNil: [ self << 'Object' ] ifNotNil: [ :declaredType | self << declaredType name ]. 
	self
		space;
		<<< aAttribute name;
		<<< ';' 
]

{ #category : #accessing }
FAMIX2JavaVisitor >> visitClass: aClass [
	| file |
	tabs := tabs + 1.
	file := self rootFolder / (aClass name , '.java').
	file deleteIfAbsent: [  ].
	currentStream := file writeStream.
	currentStream
		<< 'public class ';
		<< aClass name;
		<< ' {';
		<< String crlf.
	aClass attributes
		do: [ :attribute | 
			self clone visit: attribute.
			currentStream << String crlf ].
	self crlf.
	aClass methods
		do: [ :method | 
			self crlf.
			self clone visit: method.
			self crlf ].
	currentStream
		<< String crlf;
		<< '}'.
	currentStream
		flush;
		close
]

{ #category : #generated }
FAMIX2JavaVisitor >> visitEntity: aEntity [
	"do nothing if unknow"
]

{ #category : #accessing }
FAMIX2JavaVisitor >> visitMethod: aMethod [
	aMethod modifiers
		do: [ :modifier | 
			self
				<< modifier;
				space ].
	aMethod declaredType
		ifNotNil: [ :declaredType | 
			currentStream
				<< aMethod declaredType name;
				<< String space ].
	(aMethod name = '<Initializer>' or: [ aMethod isInitializer and: [ aMethod isConstructor not ] ]) ifFalse: [ currentStream << aMethod signature ] ifTrue: [ self << 'static' ].
	currentStream
		<< ' {';
		<< String crlf.
	self
		<< aMethod bodySourceText;
		crlf;
		<< '}'
]

{ #category : #accessing }
FAMIX2JavaVisitor >> visitNamespace: aNamespace [
	"create the folder for this namespace"
	self rootFolder: (self rootFolder / aNamespace name).
	self rootFolder ensureCreateDirectory.
	aNamespace children do: [ :child | self clone visit: child ] 
]
