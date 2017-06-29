chai = require "chai"
sinon = require "sinon"
chai.use require "sinon-chai"

expect = chai.expect

describe "remind", ->
    before ->
        @robot =
            brain:
                on: sinon.spy()
            respond: sinon.spy()
            listen: sinon.spy()

        require("../src/remind")(@robot)

    it "registers a respond listener", ->
        expect(@robot.respond).to.have.been.calledWith(/remind( me)? (.+)/i)
        expect(@robot.respond).to.have.been.calledWith(/remind cancel/i)
        expect(@robot.respond).to.have.been.calledWith(/remind( me)? now/i)
        expect(@robot.respond).to.have.been.calledWith(/remind clear/i)

    it "registers a custom listener", ->
        expect(@robot.listen).to.have.been.called

    it "registers a brain event listener", ->
        expect(@robot.brain.on).to.have.been.calledWith("loaded")
