import { Component } from "react"; 
import { Header } from "./Header";
import { MetricsResultModel, LanguageBytesDictionary, MetricsEntry } from "../model/MetricsResultModel";

type MainMetricsPageState = {
    metrics?: MetricsResultModel
}

export class MainMetricsPage extends Component<{}, MainMetricsPageState> {

    constructor(props: {}) {
        super(props);
        this.state = {}
    }

    // Rendering

    render() {
        return <div>
            <Header />
            <div className="pageContent">
                {this.renderMetrics()}
            </div>
            
        </div>
    }

    renderMetrics() {
        if (!this.state.metrics) {
            return
        }
        let count = this.state.metrics.entries.length;

        let langRows: any[] = []
        for (let i = count - 1; i > 0; --i) {
            let week = this.state.metrics.entries[i];
            langRows.push(this.weekDisplay(week))
        }
        
        return <div className="horiz-carousel">
            {langRows}
        </div>
    }

    weekDisplay(entry: MetricsEntry) {
        let totalCommits = 0;
        let lineChanges: LanguageBytesDictionary = {};
        for (const name in entry.repos) {
            const repo = entry.repos[name]
            totalCommits += repo.diff?.commitCount || 0
            for (const lang in repo.diff?.languageBytes) {
                let count = lineChanges[lang] || 0
                lineChanges[lang] = count + (repo.diff?.languageBytes[lang] || 0)
            }
        }
        let langRows: any[] = []
        for (const name in lineChanges) {
            let count = lineChanges[name]
            if (count) {
                langRows.push(<p key={name}>{name}: {count} bytes</p>)
            }
        }

        return <div key={entry.week} className="week-column">
            <h2>{entry.week}</h2>
            <p>Commits: {totalCommits}</p>
            {langRows}
        </div>
    }

    async componentDidMount() {
        const jsonPath = "/data/metrics.json"
        let result = await fetch(jsonPath)
        let model = await result.json() as MetricsResultModel
        console.log(model)
        this.setState({metrics: model})
    }

}