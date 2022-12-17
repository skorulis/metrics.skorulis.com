import { Component } from "react"; 
import { Header } from "./Header";

export class MainMetricsPage extends Component<{}, {}> {

    // Rendering

    render() {
        return <div>
            <Header />
            <div className="pageContent">
                <h1>
                    If I had been productive, there might be some metrics here
                </h1>
            </div>
            
        </div>
    }

}