import {RescueTimeDay} from "./RescueTimeDay"

export interface MetricsResultModel {
    entries: MetricsEntry[]
}

export interface MetricsEntry {
    week: string
    repos: RepoMetricsDictionary
    timeBreakdown?: RescueTimeDay
}

export interface RepoMetricsDictionary {
    [key: string]: RepoMetrics;
}

export interface LanguageBytesDictionary {
    [key: string]: number;
}

export interface RepoMetrics {
    languageBytes: LanguageBytesDictionary
    lastPush: string
    commitCount: number
    diff?: RepoChange
}

export interface RepoChange {
    languageBytes: LanguageBytesDictionary
    commitCount: number
}