import { Component } from "react"; 
import { Header } from "./Header";

export class PageNotFound extends Component<{}, {}> {

    // Rendering

    render() {
        return <div>
            <Header />
            <div className="pageContent">
                <h1>
                    This page does not exist
                </h1>
            </div>
            
        </div>
    }

}