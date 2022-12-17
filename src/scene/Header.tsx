import { Component } from "react"; 
import CSS from 'csstype';
import {Color} from "../Theme"

import {
    Link as RouteLink
} from "react-router-dom";

export class Header extends Component<{}, {}> {

    constructor(props: {}) {
        super(props);
    }

    // Rendering

    render() {
        return <header style={containerStyle}>
            <h1 style={headerLabel}>
                <a href="/">Metrics</a>

            </h1>
      </header>
    }

}

const containerStyle: CSS.Properties = {
    background: Color.lightBG,
}

const headerLabel: CSS.Properties = {
    padding: "20px",
    margin: 0,
    display: "flex",
    justifyContent: "space-between"
}