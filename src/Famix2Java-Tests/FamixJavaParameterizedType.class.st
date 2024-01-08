Class {
	#name : #FamixJavaParameterizedType,
	#superclass : #FamixJavaType,
	#traits : 'FamixTCanImplement + FamixTImplementable + FamixTParameterizedType + FamixTWithInheritances + FamixTWithParameterizedTypeUsers',
	#classTraits : 'FamixTCanImplement classTrait + FamixTImplementable classTrait + FamixTParameterizedType classTrait + FamixTWithInheritances classTrait + FamixTWithParameterizedTypeUsers classTrait',
	#category : #'Famix2Java-Tests'
}

{ #category : #meta }
FamixJavaParameterizedType class >> annotation [

	<FMClass: #ParameterizedType super: #FamixJavaType>
	<package: #'Famix-Java-Entities'>
	<generated>
	^ self
]

{ #category : #enumerating }
FamixJavaParameterizedType >> allSubclassesDo: aBlock [
	"we override this traversal because we want to
	traverse the parameter type"

	self parameterizableClass ifNotNil: [ :a | a withSubclassesDo: aBlock ]
]

{ #category : #enumerating }
FamixJavaParameterizedType >> allSuperclassesDo: aBlock [
	"we override this traversal because we want to
	traverse the parameter type"

	self parameterizableClass ifNotNil: [ :a | a withSuperclassesDo: aBlock ]
]

{ #category : #testing }
FamixJavaParameterizedType >> isParameterizedType [
	^ true
]

{ #category : #accessing }
FamixJavaParameterizedType >> mooseNameOn: aStream [
	self parameterizableClass ifNotNil: [ :pc | pc mooseNameOn: aStream ].
	aStream nextPut: $<.
	self arguments do: [ :each | each mooseNameOn: aStream ] separatedBy: [ aStream nextPut: $, ].
	aStream nextPut: $>
]