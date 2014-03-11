'use strict';

angular.module('ximsApp')
  .value('AppSettings', {
    pagination: {maxSize: 3, itemsPerPage: 10},
    employeeAlertsType: {riskInsuranceExpired: 1,
      medicalExamExpired: 2, noInductionTraining: 3}
  });