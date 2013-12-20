directions = require '../../src/models/directions'
Cycle = require '../../src/models/cycle'
Wall = require '../../src/models/wall'

describe Cycle, ->
  describe '#navigate', ->
    beforeEach ->
      @cycle = new Cycle
      @turnDown = sinon.stub @cycle, 'turnDown'
      @turnUp = sinon.stub @cycle, 'turnUp'
      @turnLeft = sinon.stub @cycle, 'turnLeft'
      @turnRight = sinon.stub @cycle, 'turnRight'

    context 'cycle is not insert mode', ->
      beforeEach ->
        @cycle.state = Cycle.STATES.RACING

      context 'given 106', ->
        beforeEach -> @cycle.navigate(106)

        it 'turns the cycle down', ->
          expect(@turnDown).to.have.been.calledOnce

        it 'does not turn the cycle up', ->
          expect(@turnUp).to.not.have.been.called

      context 'given 107', ->
        beforeEach -> @cycle.navigate(107)

        it 'turns the cycle up', ->
          expect(@turnUp).to.have.been.calledOnce

        it 'does not turn the cycle down', ->
          expect(@turnDown).to.not.have.been.called

      context 'given 104', ->
        beforeEach -> @cycle.navigate(104)

        it 'turns the cycle left', ->
          expect(@turnLeft).to.have.been.calledOnce

        it 'does not turn the cycle up', ->
          expect(@turnUp).to.not.have.been.called

      context 'given 108', ->
        beforeEach -> @cycle.navigate(108)

        it 'turns the cycle right', ->
          expect(@turnRight).to.have.been.calledOnce

        it 'does not turn the cycle up', ->
          expect(@turnUp).to.not.have.been.called

    context 'cycle is not insert mode', ->
      beforeEach ->
        @cycle.state = Cycle.STATES.INSERTING
        @cycle.navigate(108)

      it 'does not allow a change of direction', ->
        expect(@turnDown).to.not.have.been.called
        expect(@turnUp).to.not.have.been.called
        expect(@turnLeft).to.not.have.been.called
        expect(@turnRight).to.not.have.been.called


  describe '#step', ->
    beforeEach ->
      @cycle = new Cycle({direction: directions.RIGHT})

    context 'given the cycle is exploding', ->
      beforeEach ->
        @cycle.state = Cycle.STATES.EXPLODING

      context 'given the cycle has been exploding for less than 30 ticks', ->
        it 'increments the explosion frame', ->
          @cycle.step()
          expect(@cycle.explosionFrame).to.eq(1)

      context 'given the cycle has been exploding for more than 30 ticks', ->
        beforeEach ->
          @cycle.explosionFrame = 31

        it 'sets the state to DEAD', ->
          @cycle.step()
          expect(@cycle.state).to.eq(Cycle.STATES.DEAD)

    context 'given the cycle is inserting', ->
      beforeEach ->
        @cycle.state = Cycle.STATES.INSERTING

      it 'creates a new wall', ->
        @cycle.step()
        expect(@cycle.walls).to.not.be.empty

    context 'given the cycle is racing', ->
      beforeEach ->
        @cycle.state = Cycle.STATES.RACING

      it 'does not create a new wall', ->
        @cycle.step()
        expect(@cycle.walls).to.be.empty
