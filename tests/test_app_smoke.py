import runpy
import sys
import types
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class DummyBlock:
    def __enter__(self):
        return self

    def __exit__(self, *_args):
        return False

    def metric(self, *_args, **_kwargs):
        return None


def fake_streamlit_module():
    module = types.ModuleType("streamlit")
    module.sidebar = DummyBlock()
    module.cache_data = lambda function: function
    module.set_page_config = lambda **_kwargs: None
    module.markdown = lambda *_args, **_kwargs: None
    module.title = lambda *_args, **_kwargs: None
    module.caption = lambda *_args, **_kwargs: None
    module.header = lambda *_args, **_kwargs: None
    module.multiselect = lambda _label, _options, default=None, **_kwargs: default or []
    module.checkbox = lambda *_args, value=False, **_kwargs: value
    module.divider = lambda: None
    module.columns = lambda spec: [DummyBlock() for _ in range(spec if isinstance(spec, int) else len(spec))]
    module.tabs = lambda labels: [DummyBlock() for _ in labels]
    module.subheader = lambda *_args, **_kwargs: None
    module.dataframe = lambda *_args, **_kwargs: None
    module.bar_chart = lambda *_args, **_kwargs: None
    module.selectbox = lambda _label, options, **_kwargs: options[0]
    module.write = lambda *_args, **_kwargs: None
    module.metric = lambda *_args, **_kwargs: None
    module.warning = lambda *_args, **_kwargs: None
    module.error = lambda *_args, **_kwargs: None
    module.stop = lambda: (_ for _ in ()).throw(RuntimeError("st.stop called"))
    return module


class AppSmokeTests(unittest.TestCase):
    def test_app_executes_with_streamlit_contract_stub(self):
        previous = sys.modules.get("streamlit")
        sys.modules["streamlit"] = fake_streamlit_module()
        try:
            runpy.run_path(str(ROOT / "app.py"), run_name="__main__")
        finally:
            if previous is None:
                sys.modules.pop("streamlit", None)
            else:
                sys.modules["streamlit"] = previous


if __name__ == "__main__":
    unittest.main()
