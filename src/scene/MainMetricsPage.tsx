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

    async componentDidMount() {
        const jsonPath = "/data/metrics.json"
        let result = await fetch(jsonPath)
        let text = await result.json()
        console.log(text)
    }

}