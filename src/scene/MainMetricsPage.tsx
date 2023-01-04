import { Component } from "react"; 
import { Header } from "./Header";
import { MetricsResultModel, LanguageBytesDictionary, MetricsEntry } from "../model/MetricsResultModel";
import { RescueTimeDay } from "../model/RescueTimeDay";
import { PieChart, Pie, Cell } from 'recharts';

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
            {this.timeDisplay(entry.timeBreakdown)}
        </div>
    }

    timeDisplay(time?: RescueTimeDay) {
        if (!time) {
            return;
        }
        return <div>
            <p>Hours recorded: {time.total_hours}</p>
            {this.pieChart(time)}
        </div>
    }

    pieChart(time: RescueTimeDay) {
        let data = this.pieData(time);
        return <PieChart width={200} height={200}>
            <Pie dataKey="value" nameKey="name" data={data}>
            {
            data.map((entry, index) => (
                <Cell key={index} fill={entry.color} />
            ))}
            </Pie>
        </PieChart>
    }

    pieData(time: RescueTimeDay) {
        return [
            {color: "Red", value: time.very_distracting_hours},
            {color: "Pink", value: time.distracting_hours},
            {color: "Gray", value: time.neutral_hours},
            {color: "Cyan", value: time.productive_hours},
            {color: "Blue", value: time.very_productive_hours},
        ]
    }

    async componentDidMount() {
        const jsonPath = "/data/metrics.json"
        let result = await fetch(jsonPath)
        let model = await result.json() as MetricsResultModel
        console.log(model)
        this.setState({metrics: model})
    }

}