export interface MetricsResultModel {
    entries: MetricsEntry[]
}

export interface MetricsEntry {
    week: string
    repos: {string: RepoMetrics}
}

export interface RepoMetrics {
    languageBytes: {string: Number}
    lastPush: string
    commitCount: Number
    diff?: RepoChange
}

export interface RepoChange {
    languageBytes: {string: Number}
    commitCount: Number
}