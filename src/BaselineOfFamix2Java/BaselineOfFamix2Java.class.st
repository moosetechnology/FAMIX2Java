Class {
	#name : #BaselineOfFamix2Java,
	#superclass : #BaselineOf,
	#category : #BaselineOfFamix2Java
}

{ #category : #baselines }
BaselineOfFamix2Java >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec ]
]

{ #category : #baselines }
BaselineOfFamix2Java >> defineDependencies: spec [
]

{ #category : #baselines }
BaselineOfFamix2Java >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfFamix2Java >> definePackages: spec [

	spec
		package: 'Famix-Compatibility-Visitor';
		package: 'Famix2Java'
		with: [ spec requires: #( 'Famix-Compatibility-Visitor' ) ];
		package: 'Famix2Java-Tests'
		with: [ spec requires: #( 'Famix2Java' ) ]
]
