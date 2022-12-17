import { Component } from "react"; 
import './css/App.css';
import { PageNotFound} from "./scene/PageNotFound"
import { MainMetricsPage } from "./scene/MainMetricsPage";

import {
  HashRouter as Router,
  Route,
  Routes,
  useParams,
} from "react-router-dom";


export default class App extends Component<{}> {

  render() {
    return (
      <div className='main'>
        {this.router()}
        <footer className="mainFooter">
          Copyright © Alex Skorulis          
        </footer>
      </div>
    );
  }

  router() {
    return <Router>
        <Routes>
        <Route path="/" element={<MainMetricsPage />} />
          <Route path="*" element={<PageNotFound />} />
      </Routes>
    </Router>
  }
}
