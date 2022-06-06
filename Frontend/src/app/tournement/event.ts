export class Event{
    teamA: string;
    teamB: string;
    scoreA: number;
    scoreB: number;
    picA: string;
    picB: string;
    eventNumber: number;
    constructor(teamA: string, teamB: string, scoreA: number, scoreB: number, eventNumber: number){
        this.teamA = teamA;
        this.teamB = teamB;
        this.scoreA = scoreA;
        this.scoreB = scoreB;
        this.eventNumber = eventNumber;
    }
}