use bytes::Bytes;
use chardetng;
use magnus::{function, method, prelude::*, Error, Ruby};
use std::cell::RefCell;

#[magnus::wrap(class="CharDetNg::Internal::EncodingDetector", free_immediately, size)]
struct EncodingDetector {
    inner: RefCell<chardetng::EncodingDetector>
}

impl EncodingDetector {
    pub fn new() -> Self {
	Self {
	    inner: RefCell::new(chardetng::EncodingDetector::new())
	}
    }

    pub fn feed(&self, buffer: Bytes, last: bool) -> bool {
	self.inner.borrow_mut().feed(&buffer, last)
    }

    pub fn guess_assess(&self, tld: Option<Bytes>, allow_utf8: bool) -> (String, bool) {
	let (enc, is_reliable) =
	    match tld {
		Some(bytes) =>
		    self.inner.borrow().guess_assess(Some(&bytes), allow_utf8),
		None =>
		    self.inner.borrow().guess_assess(None, allow_utf8)
	    };

	(String::from(enc.name()), is_reliable)
    }

    pub fn guess(&self, tld: Option<Bytes>, allow_utf8: bool) -> String {
	let (enc, _is_reliable) = self.guess_assess(tld, allow_utf8);
	enc
    }
}

#[magnus::init]
pub fn init(ruby: &Ruby) -> Result<(), Error> {
    let module = ruby.define_module("CharDetNg")?;
    let internal = module.define_module("Internal")?;
    let class = internal.define_class("EncodingDetector", ruby.class_object())?;
    class.define_singleton_method("new", function!(EncodingDetector::new, 0))?;
    class.define_method("feed", method!(EncodingDetector::feed, 2))?;
    class.define_method("guess_assess", method!(EncodingDetector::guess_assess, 2))?;
    class.define_method("guess", method!(EncodingDetector::guess, 2))?;

    Ok(())
}
