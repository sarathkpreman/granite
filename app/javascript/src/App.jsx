import React from "react";

import { Route, Switch, BrowserRouter as Router } from "react-router-dom";

import Dashboard from "components/Dashboard";
import CreateTask from "components/Tasks/Create";

const App = () => (
  <Router>
    <Switch>
      <Route exact component={CreateTask} path="/tasks/create" />
      <Route exact component={Dashboard} path="/dashboard" />
      <Route exact path="/" render={() => <div>Home</div>} />
      <Route exact path="/about" render={() => <div>About</div>} />
    </Switch>
  </Router>
);

export default App;
