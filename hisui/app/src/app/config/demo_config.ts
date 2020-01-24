export default {
  CREDENTIALS:{
    userName: "SuperUser",
    password: "sys"
  },
  URL:{
    userList: 'http://'+window.location.hostname+':9096/csp/appint/rest/encounter/list',
    admissionsList: 'http://'+window.location.hostname+':9096/csp/appint/rest/encounter/admissionslist',
    dischargeUser: 'http://'+window.location.hostname+':9096/csp/appint/rest/encounter/discharge',
    resetDemo: 'http://'+window.location.hostname+':9096/csp/appint/rest/encounter/resetdemo',

    workflow:{
      root: 'http://'+window.location.hostname+':9092/csp/appint/rest/workflow/',
      tasks: 'tasks',
      clear: 'tasks/clear',
      task: 'task',
      assign: 'task/assign',
      unassign: 'task/unassign',
      complete: 'task/complete'
    },

    cube:{
      root: 'http://'+window.location.hostname+':9094/csp/appint/rest/cube/',
      getABTCubeData: 'getcubedataforencounter',
    },

    prediction:{
      root: 'http://'+window.location.hostname+':9094/csp/appint/rest/predict/',
      getPrediction: 'calculateprediction',
    }
  }
}
