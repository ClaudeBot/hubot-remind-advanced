chai = require "chai"
sinon = require "sinon"
chai.use require "sinon-chai"

expect = chai.expect

describe "remind", ->
    beforeEach ->
        @robot =
            respond: sinon.spy()
            hear: sinon.spy()

        require("../src/remind")(@robot)

    it "registers a respond listener", ->
        expect(@robot.respond).to.have.been.calledWith(/remind cancel/i)
        expect(@robot.respond).to.have.been.calledWith(/remind( me)? (.+)/i)

    it "registers a hear listener", ->
        expect(@robot.hear).to.have.been.calledWith(/(.+)/i)
