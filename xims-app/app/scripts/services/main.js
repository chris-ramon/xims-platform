'use strict';

angular.module('ximsApp')
  .service('ModuleService', function () {
    var self = this;
    self.HOME = 'home';
    self.TRAINING = 'training';
    self.EMPLOYEE = 'employee';
    self.name = name;
    return self;
  })
  .service('EmployeeService', function() {
    var self = this;
    self.getAll = function() {
      return [
        {id: 1, dni: 45996135, displayName: 'Chris Ramón', firstName: 'Chris', middleName: 'Ramón'},
        {id: 2, dni: 45996556, displayName: 'Roger Rodriguez', firstName: 'Roger', middleName: 'Rodriguez'},
        {id: 3, dni: 45336556, displayName: 'Luis Rodriguez', firstName: 'Luis', middleName: 'Rodriguez'},
        {id: 4, dni: 45966556, displayName: 'John Doe', firstName: 'John', middleName: 'Doe', supplementaryRiskInsurance: {expired: true}},
        {id: 5, dni: 45998556, displayName: 'Michael Lara', firstName: 'Michael', middleName: 'Lara', supplementaryRiskInsurance: {expired: true}},
        {id: 6, dni: 45996956, displayName: 'Juan Perez', firstName: 'Juan', middleName: 'Perez', medicalExam: {expired: true}}]
    }
  })
  .service('CompanyService', function() {
    var self = this;
    var company = {
      name: 'Empresa de Clase Mundial SAC',
      uniqueNumber: '8797979797',
      address: 'Av. Alfredo Benavides #708',
      economicActivity: 'Explotación de Minas y Canteras',
      totalNumberEmployees: 678,
      employees: [
      {dni: 45996135, name: 'Chris Ramón'},
      {dni: 45996556, name: 'Roger Rodriguez'},
      {dni: 45336556, name: 'Luis Rodriguez'},
      {dni: 45966556, name: 'John Doe'},
      {dni: 45998556, name: 'Michael Lara'},
      {dni: 45996956, name: 'Juan Perez'}
      ]
    };
    self.getCompany = function() {
      if(company) {
        return company;
      } else {
        // fetches company information from server
        return null;
      }
    }
    return self;
  })
  .service('TrainingService', function() {
    var self = this;
    self.getAll = function() {
      return [{id: 1, registryNumber: 434, topic: 'Primeros Auxilios', dateOfTraining: '12/12/2013', numberOfTrainingHours: 5},
        {id: 2, registryNumber: 435, topic: 'Trabajos en Altura', dateOfTraining: '12/12/2013', numberOfTrainingHours: 6},
        {id: 3, registryNumber: 436, topic: 'Primeros Auxilios II', dateOfTraining: '12/12/2013', numberOfTrainingHours: 3},
        {id: 4, registryNumber: 437, topic: 'Trabajos en espacios confinados', dateOfTraining: '12/12/2013', numberOfTrainingHours: 7}]
    }
  });
