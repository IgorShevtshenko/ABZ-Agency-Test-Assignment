# ABZ Agency Middle iOS Engineer Test Assignment

## Table of Contents
- [Dependencies](#dependencies)
- [Architecture](#architecture)
- [Modules](#modules)

## Dependencies

- [PhoneNumberKit](https://github.com/marmelroy/PhoneNumberKit.git)
This library used for parsing, formatting and validating international phone numbers

## Architecture 

Clean architecture + MVVM <br />
For dependency injection is used Composition root

## Modules

### Infrastructure:
 Module that contains Repositories, NetworkClient. Repository holds application shared data

### UseCases: 
Module that contains UseCases. Each UseCase contains some business logic, can call 1 or more Repositories or other UseCases to apply business logic to it

### Nodes:
 Module containing ViewModel + View. Each node represent some UI part with its logic

- ViewModel: Holds the State receive Actions from View and modify State from receiving Events using reduce function.
- View: Simple SwiftUI View that renders UI observing ViewModels' State and forward user interactions to ViewModel

### Utils:
 Module that contains simple helpers, extensions, and utility tools

### UILibrary:
 Module for App Design System(UIKit). Contains colors, fonts, button styles and etc.

