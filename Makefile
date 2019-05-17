.PHONY: clean test lint

TEST_PATH=./

help:
	@echo "    train-nlu"
	@echo "        Train the natural language understanding using Rasa NLU."
	@echo "    train-core"
	@echo "        Train a dialogue model using Rasa core."
	@echo "    run-cmdline"
	@echo "        Starts the bot on the command line"
	@echo "    visualize"
	@echo "        Saves the story graphs into a file"

run-actions:
	python3 -m rasa_core_sdk.endpoint --actions demo.actions

train-nlu:
	python3 -m rasa.nlu.train -c nlu_tensorflow.yml -d data/bert/train.md -o models --debug

train-core:
	python3 -m rasa_core.train -d domain.yml -s data/core -c policy.yml --debug -o models/dialogue --augmentation 0

train-memo:
	python -m rasa_core.train -d domain.yml -s data/core -c augmentedmemo-only.yml -o models/dialogue --augmentation 0

run-core:
	python3 -m rasa_core.run -d models/dialogue -u models/nlu/current --debug --endpoints endpoints.yml

visualize:
	python3 -m rasa_core.visualize -s data/core/ -d domain.yml -o story_graph.png

train-online:
	python -m rasa_core.train -u models/nlu/current/ --online --core models/dialogue/

evaluate-core:
	python -m rasa_core.evaluate --core models/dialogue -s data/core/ --fail_on_prediction_errors

evaluate-nlu:
	python3 -m rasa_nlu.test --data data/bert/test.md --model models/nlu_20190513-182802

evaluate-nlu-1:
	python3 -m rasa_nlu.evaluate --data data/valid_personachat_other_original_nlu.md --model models/nlu/current
