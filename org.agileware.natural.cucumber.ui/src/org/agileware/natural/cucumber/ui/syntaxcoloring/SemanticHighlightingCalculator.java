package org.agileware.natural.cucumber.ui.syntaxcoloring;

import static org.agileware.natural.cucumber.ui.syntaxcoloring.HighlightingConfiguration.META_TAG_ID;
import static org.agileware.natural.cucumber.ui.syntaxcoloring.HighlightingConfiguration.PLACEHOLDER_ID;
import static org.agileware.natural.cucumber.ui.syntaxcoloring.HighlightingConfiguration.STEP_KEYWORD_ID;
import static org.agileware.natural.cucumber.ui.syntaxcoloring.HighlightingConfiguration.TABLE_ID;

import org.agileware.natural.cucumber.cucumber.AbstractScenario;
import org.agileware.natural.cucumber.cucumber.CucumberModel;
import org.agileware.natural.cucumber.cucumber.Example;
import org.agileware.natural.cucumber.cucumber.Feature;
import org.agileware.natural.cucumber.cucumber.Meta;
import org.agileware.natural.cucumber.cucumber.MetaTag;
import org.agileware.natural.cucumber.cucumber.ScenarioOutline;
import org.agileware.natural.cucumber.cucumber.Step;
import org.agileware.natural.cucumber.cucumber.Table;
import org.eclipse.emf.common.util.EList;
import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor;
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator;
import org.eclipse.xtext.nodemodel.INode;
import org.eclipse.xtext.nodemodel.util.NodeModelUtils;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.util.CancelIndicator;

public class SemanticHighlightingCalculator implements ISemanticHighlightingCalculator {

	@Override
	public void provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor,
			CancelIndicator cancelIndicator) {
		if (resource == null || resource.getParseResult() == null || resource.getContents().size() <= 0) {
			return;
		}

		Feature feature = ((CucumberModel) resource.getContents().get(0)).getFeature();
		if (feature == null) {
			return;
		}

		provideHighlightingForMeta(feature.getMeta(), acceptor);
		
		if (feature.getBackground() != null) {
			provideHighlightingForMeta(feature.getBackground().getMeta(), acceptor);
			provideHighlightingForSteps(feature.getBackground().getSteps(), acceptor);
		}
		
		for (AbstractScenario scenario : feature.getScenarios()) {
			provideHighlightingForMeta(scenario.getMeta(), acceptor);
			provideHighlightingForSteps(scenario.getSteps(), acceptor);
			if (scenario instanceof ScenarioOutline) {
				provideHighlightingForExamples(((ScenarioOutline) scenario).getExamples(), acceptor);
			}
		}
	}

	/**
	 * Loops through each tag and applies highlighting rules to semantic regions, or
	 * returns early if meta is null.
	 * 
	 * @param meta
	 * @param acceptor
	 */
	private void provideHighlightingForMeta(Meta meta, IHighlightedPositionAcceptor acceptor) {
		if (meta == null)
			return;

		for (MetaTag tag : meta.getTags()) {
			INode node = NodeModelUtils.getNode(tag);
			acceptor.addPosition(node.getOffset(), node.getText().length(), META_TAG_ID);
		}
	}

	/**
	 * Loops through each example and applies highlighting rules to semantic
	 * regions.
	 * 
	 * @param steps
	 * @param acceptor
	 */
	private void provideHighlightingForExamples(EList<Example> examples, IHighlightedPositionAcceptor acceptor) {
		for (Example example : examples) {
			provideHighlightingForMeta(example.getMeta(), acceptor);
			provideHighlightingForTable(example.getTable(), acceptor);
		}
	}

	/**
	 * Loops through each step and applies highlighting rules to semantic regions.
	 * 
	 * @param steps
	 * @param acceptor
	 */
	private void provideHighlightingForSteps(EList<Step> steps, IHighlightedPositionAcceptor acceptor) {
		for (Step step : steps) {
			INode node = NodeModelUtils.getNode(step);
			acceptor.addPosition(node.getOffset(), node.getText().trim().indexOf(" "), STEP_KEYWORD_ID);
			if (step.eContainer() instanceof ScenarioOutline && step.getDescription() != null) {
				this.provideHighlightingForPlaceholders(node.getText(), node, 0, acceptor);
			}
		}
	}

	private void provideHighlightingForPlaceholders(String description, INode node, int current,
			IHighlightedPositionAcceptor acceptor) {
		int start = description.indexOf('<', current);
		int stop = description.indexOf('>', start);
		if (start > 0 && stop > 0 && description.charAt(start + 1) != ' ') {
			acceptor.addPosition(node.getTotalOffset() + start, stop - start + 1, PLACEHOLDER_ID);
			this.provideHighlightingForPlaceholders(description, node, stop + 1, acceptor);
		}
	}

	/**
	 * Loops through each tag and applies highlighting rules to semantic regions, or
	 * returns early if meta is null.
	 * 
	 * @param meta
	 * @param acceptor
	 */
	private void provideHighlightingForTable(Table table, IHighlightedPositionAcceptor acceptor) {
		if (table == null)
			return;
		INode node = NodeModelUtils.getNode(table);
		acceptor.addPosition(node.getOffset(), node.getText().length(), TABLE_ID);
	}

}